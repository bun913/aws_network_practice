# エラーログ配信用
resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/ecs/${var.project}-error-logs"
  tags              = var.tags
  retention_in_days = 90
}

# FireHose自体のロギング用
resource "aws_cloudwatch_log_group" "firehose" {
  name              = "/aws/kinesisfirehose/${var.project}-firehose-logs"
  tags              = var.tags
  retention_in_days = 30
}

# デリバリーログ配信用
resource "aws_kinesis_firehose_delivery_stream" "firelens" {
  name        = "${var.project}-deliverystream"
  destination = "s3"

  s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.app_logs.arn

    cloudwatch_logging_options {
      enabled         = "true"
      log_group_name  = aws_cloudwatch_log_group.firehose.id
      log_stream_name = "firehose_error"
    }
  }
}

# デリバリーログ長期保存用
resource "aws_s3_bucket" "app_logs" {
  acl = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
