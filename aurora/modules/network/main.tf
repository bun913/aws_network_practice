# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags       = merge({ "Name" : var.project }, var.tags)
}

# private_subnet_for_db
resource "aws_subnet" "db" {
  for_each   = { for s in var.subnets : s.name => s }
  cidr_block = each.value.cidr_block
  vpc_id     = aws_vpc.main.id
  tags       = merge({ "Name" = "${var.project}-${each.key}" }, var.tags)
}
