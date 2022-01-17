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
  name = "${var.project}-build-policy"
  role = aws_iam_role.codebuild_service_role.name
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "ecr:BatchCheckLayerAvailability",
            "ecr:CompleteLayerUpload",
            "ecr:GetAuthorizationToken",
            "ecr:InitiateLayerUpload",
            "ecr:PutImage",
            "ecr:UploadLayerPart",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
        },
        {
          "Effect" : "Allow",
          "Resource" : [
            "*"
          ],
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
        },
        {
          "Effect" : "Allow",
          "Resource" : [
            "*"
          ],
          "Action" : [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetObjectVersion"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : "ssm:GetParameters",
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "ec2:CreateNetworkInterface",
            "ec2:DescribeDhcpOptions",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface",
            "ec2:DescribeSubnets",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeVpcs",
            "ec2:CreateNetworkInterfacePermission"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}
