# エラーログをSNSにパブリッシュするLambda関数
data "archive_file" "sns_publish_func" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda/sns_publish.zip"
}

resource "aws_lambda_function" "sns_publish_func" {
  filename         = data.archive_file.sns_publish_func.output_path
  function_name    = "${var.project}_sns_publish"
  role             = aws_iam_role.lambda_sns_publish.arn
  handler          = "index.lambda_handler"
  source_code_hash = data.archive_file.sns_publish_func.output_base64sha256
  runtime          = "python3.9"

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.notificate.arn
      ALARM_SUBJECT = "【Error Notification】${var.project}"
    }
  }
}

resource "aws_lambda_permission" "log_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns_publish_func.arn
  principal     = "logs.ap-northeast-1.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.app.arn}:*"
}
