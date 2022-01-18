resource "aws_codedeploy_app" "app" {
  compute_platform = "ECS"
  name             = "${var.project}-deploy"
}
resource "aws_codedeploy_deployment_group" "app" {
  app_name               = aws_codedeploy_app.app.name
  deployment_config_name = "CodeDeployDefault.ECSLinear10PercentEvery1Minutes"
  deployment_group_name  = "${var.project}-dg"
  service_role_arn       = aws_iam_role.codedeploy_role.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.cluster_name
    service_name = var.service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.blue_listner_arn]
      }
      test_traffic_route {
        listener_arns = [var.green_listner_arn]
      }
      target_group {
        name = var.blue_targetgroup_name
      }
      target_group {
        name = var.green_targetgroup_name
      }
    }
  }
  tags = var.tags
}
