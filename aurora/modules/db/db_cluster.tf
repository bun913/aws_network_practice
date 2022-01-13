# rds cluster group
resource "aws_rds_cluster" "main" {
  cluster_identifier              = var.cluster_settings.cluster_name
  engine                          = var.cluster_settings.engine
  engine_version                  = var.cluster_settings.engine_version
  availability_zones              = var.cluster_settings.availability_zones
  database_name                   = var.cluster_settings.database_name
  master_username                 = var.cluster_settings.master_username
  master_password                 = var.cluster_settings.master_password
  backup_retention_period         = var.cluster_settings.backup_retention_period
  db_subnet_group_name            = aws_db_subnet_group.main.id
  vpc_security_group_ids          = [aws_security_group.db.id]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.main.id
  # NOTE: お試しようなので削除保護をfalseにしている。本番では必ず設定する
  deletion_protection = false
  skip_final_snapshot = true
}

# clusterのパスワードを変更する
resource "null_resource" "cluster" {
  # DBが作成されたことをトリガーにする
  triggers = {
    cluster_instance_ids = aws_rds_cluster.main.id
  }
  provisioner "local-exec" {
    # aws cliでRDSのパスワードを変更する
    command    = "aws ssm get-parameter --name /${var.project}/db_password --query 'Parameter.Value' --with-decryption | xargs -IPASS aws rds modify-db-cluster --db-cluster-identifier ${aws_rds_cluster.main.id} --master-user-password PASS --apply-immediately"
    on_failure = fail
  }
}

# rds_instance
resource "aws_rds_cluster_instance" "example" {
  count                   = 2
  cluster_identifier      = aws_rds_cluster.main.id
  identifier              = "${aws_rds_cluster.main.id}-${count.index}"
  engine                  = aws_rds_cluster.main.engine
  engine_version          = aws_rds_cluster.main.engine_version
  instance_class          = var.instance_class
  db_subnet_group_name    = aws_db_subnet_group.main.name
  db_parameter_group_name = aws_db_parameter_group.main.name
  /* monitoring_role_arn = aws_iam_role.aurora_monitoring.arn */
  /* monitoring_interval = 60 */
  publicly_accessible = false
}
