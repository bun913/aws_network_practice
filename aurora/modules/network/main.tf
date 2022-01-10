# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  tags                 = merge({ "Name" : var.project }, var.tags)
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# private_subnet_for_db
resource "aws_subnet" "db" {
  for_each          = { for s in var.db_subnets : s.name => s }
  cidr_block        = each.value.cidr_block
  vpc_id            = aws_vpc.main.id
  availability_zone = each.value.az
  tags              = merge({ "Name" = "${var.project}-${each.key}" }, var.tags)
}


# private_subnet_for_bastion
resource "aws_subnet" "bastion" {
  for_each          = { for s in var.bastion_subnets : s.name => s }
  cidr_block        = each.value.cidr_block
  vpc_id            = aws_vpc.main.id
  availability_zone = each.value.az
  tags              = merge({ "Name" = "${var.project}-${each.key}" }, var.tags)
}
# VPC RouteTable
resource "aws_route_table" "db" {
  vpc_id = aws_vpc.main.id
  tags   = merge({ "Name" : "${var.project}-route-db" }, var.tags)
}

resource "aws_route_table" "bastion" {
  vpc_id = aws_vpc.main.id
  tags   = merge({ "Name" : "${var.project}-route-bastion" }, var.tags)
}

# RouteTableAssociation for db
resource "aws_route_table_association" "db" {
  for_each       = { for sb in var.db_subnets : sb.name => sb }
  subnet_id      = aws_subnet.db[each.key].id
  route_table_id = aws_route_table.db.id
}

# RouteTableAssociation for bastion
resource "aws_route_table_association" "bastion" {
  for_each       = { for sb in var.bastion_subnets : sb.name => sb }
  subnet_id      = aws_subnet.bastion[each.key].id
  route_table_id = aws_route_table.bastion.id
}
