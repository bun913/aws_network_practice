# rds cluster group
resource "aws_rds_cluster" "main" {
  cluster_identifier      = var.cluster_settings.cluster_name
  engine                  = var.cluster_settings.engine
  engine_version          = var.cluster_settings.engine_version
  availability_zones      = var.cluster_settings.availability_zones
  database_name           = var.cluster_settings.database_name
  master_username         = var.cluster_settings.master_username
  master_password         = var.cluster_settings.master_password
  backup_retention_period = var.cluster_settings.backup_retention_period
  db_subnet_group_name    = aws_db_subnet_group.main.id
  # NOTE: お試しようなので削除保護をfalseにしている。本番では必ず設定する
  deletion_protection = false
  skip_final_snapshot = true
}
