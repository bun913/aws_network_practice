output "db_subnet_ids" {
  value = [
    for sb in aws_subnet.db : sb.id
  ]
}

output "bastion_subnet_ids" {
  value = [
    for sb in aws_subnet.bastion : sb.id
  ]
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "db_route_table_id" {
  value = aws_route_table.db.id
}

output "bastion_route_table_id" {
  value = aws_route_table.bastion.id
}
