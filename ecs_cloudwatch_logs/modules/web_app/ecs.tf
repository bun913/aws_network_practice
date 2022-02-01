resource "aws_ecs_cluster" "app" {
  name = "${var.project}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT"
  ]
  tags = var.tags

  depends_on = [
    aws_lb.app
  ]
}

resource "aws_ecs_task_definition" "app" {
  family        = "${var.project}-task-def"
  task_role_arn = aws_iam_role.ecs_task.arn
  network_mode  = "awsvpc"
  requires_compatibilities = [
    "FARGATE"
  ]
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  memory             = "512"
  cpu                = "256"
  container_definitions = jsonencode([
    {
      name      = "color"
      image     = "${aws_ecr_repository.app.repository_url}:v1"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ],
      environment = [
        {
          "name" : "APP_COLOR",
          "value" : "blue"
        }
      ],
      logConfiguration = {
        logDriver = "awsfirelens"
      }
    },
    {
      essential         = true,
      name              = "log_router",
      image             = "${aws_ecr_repository.firelens.repository_url}:v1",
      memoryReservation = 50,
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.firehose.name,
          awslogs-region        = var.region,
          awslogs-stream-prefix = "app-sidecar"
        }
      },
      firelensConfiguration = {
        type = "fluentbit",
        options = {
          config-file-type  = "file",
          config-file-value = "/fluent-bit/etc/extra.conf"
        }
      }
    }
  ])

  volume {
    name = "app-storage"
  }

  depends_on = [
    aws_lb.app,
    null_resource.fluentbit,
    null_resource.app
  ]

  tags = var.tags
}

resource "aws_ecs_service" "app" {
  name    = "${var.project}-service"
  cluster = aws_ecs_cluster.app.id
  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 1
    weight            = 1
  }

  platform_version                   = "1.4.0"
  task_definition                    = aws_ecs_task_definition.app.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  load_balancer {
    target_group_arn = aws_lb_target_group.app_blue.arn
    container_name   = "color"
    container_port   = 8080
  }

  deployment_controller {
    # TODO: CodeDeployによるデプロイの場合CODE_DEPLOYにする
    # 今回はそこはスコープではないため省略する
    type = "ECS"
  }

  health_check_grace_period_seconds = 60
  network_configuration {
    assign_public_ip = false
    security_groups = [
      aws_security_group.ecs_service.id
    ]
    subnets = var.private_subnets
  }

  # ECS Exec用
  enable_execute_command = true

  tags = var.tags

  lifecycle {
    ignore_changes = [
      load_balancer,
      desired_count,
    ]
  }

}
