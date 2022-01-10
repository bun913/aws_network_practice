# security_group
resource "aws_security_group" "allow_https_inbound" {
  name        = var.security_group_name
  description = "Allow HTTPS inbound"
  vpc_id      = var.vpc_id

  ingress {
    description = "Inbound from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  tags = var.tags
}
