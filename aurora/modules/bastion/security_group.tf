# security_group
resource "aws_security_group" "allow_https_inbound" {
  name        = var.inbound_sg_name
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
resource "aws_security_group" "allow_https_outbound" {
  name        = var.outbound_sg_name
  description = "Allow HTTPS inbound"
  vpc_id      = var.vpc_id

  egress {
    description = "OutBound from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}
