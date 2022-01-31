resource "aws_rds_cluster_parameter_group" "main" {
  name   = var.cluster_settings.cluster_name
  family = "aurora-mysql5.7"
  tags   = var.tags
  parameter {
    name         = "character_set_client"
    value        = "utf8mb4"
    apply_method = "immediate"
  }
  parameter {
    name         = "character_set_server"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_connection"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_database"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_connection"
    value        = "utf8mb4_bin"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_server"
    value        = "utf8mb4_bin"
    apply_method = "immediate"
  }

  parameter {
    name         = "time_zone"
    value        = "Asia/Tokyo"
    apply_method = "immediate"
  }
}
# db_parameter_group
resource "aws_db_parameter_group" "main" {
  name = var.cluster_settings.cluster_name
  # FIXME: 繰り返し項目・除去したい
  family = "aurora-mysql5.7"
}
