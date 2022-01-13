resource "aws_security_group" "ingress_all" {
  name        = "ingress_all"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from internal"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from internal"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}
resource "aws_lb" "app" {
  name               = var.alb_name
  internal           = true
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
