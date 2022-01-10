# サブネットグループ for aurora
resource "aws_db_subnet_group" "main" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids
  tags       = var.tags
}
