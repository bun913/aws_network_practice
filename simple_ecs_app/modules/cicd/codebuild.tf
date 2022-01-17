resource "aws_codebuild_project" "app" {
  name         = "${var.project}-deploy"
  service_role = aws_iam_role.codebuild_service_role.arn
  description  = "Build App image for deployment"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:2.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    environment_variable {
      name  = "APP_IMAGE_REPO"
      value = var.ecr_repo
    }
    environment_variable {
      name  = "REGION"
      value = var.region
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

}
