resource "aws_iam_role" "codebuild_service_role" {
  name = "role-codebuild-service-role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "codebuild.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "codebuild_service_role" {
  name   = "${var.project}-build-policy"
  role   = aws_iam_role.codebuild_service_role.name
  policy = file("${path.root}/files/codebuild_policy.json")
}

resource "aws_iam_role" "codedeploy_role" {
  name = "${var.project}-code-deploy-role"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "codedeploy.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "codedeploy_role" {
  name   = "${var.project}-deploy-policy"
  role   = aws_iam_role.codedeploy_role.name
  policy = file("${path.root}/files/codedeploy_policy.json")
}

resource "aws_iam_role" "codepipeline_service_role" {
  name = "${var.project}-code-pipeline-role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "codepipeline.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "codepipeline_service_role" {
  name   = "${var.project}-code-pipeline-policy"
  role   = aws_iam_role.codepipeline_service_role.name
  policy = file("${path.root}/files/code_pipeline_policy.json")
}
