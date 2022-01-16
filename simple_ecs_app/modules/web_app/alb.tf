resource "aws_lb" "app" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ingress_all.id]
  subnets            = var.alb_subnets

  # テストようなので保護機能を有効にしない
  enable_deletion_protection = false

  # テスト用なのでアクセスログは吐き出さない
  /* access_logs { */
  /*   bucket  = aws_s3_bucket.lb_logs.bucket */
  /*   prefix  = "test-lb" */
  /*   enabled = true */
  /* } */
  tags = var.tags
}
# NOTE: 今回はHTTPSは利用しない
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "HTTP"
  # TODO: 一旦動作確認用のため、ECSサービスができたらそちらにforwardすること
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn

  }
}

resource "aws_lb_target_group" "app" {
  name                 = "${var.project}-tg"
  deregistration_delay = 60
  port                 = 8080
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  health_check {
    healthy_threshold   = 2
    interval            = 30
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
  tags = var.tags
}
