resource "aws_ecs_cluster" "web" {
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
}

