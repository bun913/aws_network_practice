resource "aws_codepipeline" "app-deploy" {
  name     = "${var.project}-deploy"
  role_arn = aws_iam_role.codepipeline_service_role.arn

  artifact_store {
    location = aws_s3_bucket.pipeline.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      run_order        = 1

      configuration = {
        # Applyの後にマネジメントコンソールからGithub認証を行う
        ConnectionArn    = var.code_star_connection_arn
        FullRepositoryId = var.repository_id
        # ステージング環境ならdevelopという風に調整する
        BranchName = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"
      run_order        = 2

      configuration = {
        ProjectName = aws_codebuild_project.app.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name     = "Deploy"
      category = "Deploy"
      owner    = "AWS"
      # https://docs.aws.amazon.com/ja_jp/codepipeline/latest/userguide/action-reference-ECSbluegreen.html
      provider        = "CodeDeployToECS"
      input_artifacts = ["build_output", "source_output"]
      version         = "1"
      run_order       = 3

      configuration = {
        # taskdef.json と appspec.ymlはアプリ側リポジトリのルートに配置する必要がある
        ApplicationName                = aws_codedeploy_app.app.name
        DeploymentGroupName            = aws_codedeploy_deployment_group.app.deployment_group_name
        TaskDefinitionTemplateArtifact = "source_output"
        TaskDefinitionTemplatePath     = "taskdef.json"
        AppSpecTemplateArtifact        = "source_output"
        AppSpecTemplatePath            = "appspec.yaml"
        Image1ArtifactName             = "build_output"
        Image1ContainerName            = "IMAGE1_NAME"
      }
    }
  }

  tags = var.tags
}
