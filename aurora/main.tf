provider "aws" {
  region = "ap-northeast-1"
}
# ネットワーク
module "network" {
  source          = "./modules/network/"
  tags            = var.tags
  db_subnets      = var.db_subnets
  bastion_subnets = var.bastion_subnets
  vpc_cidr        = var.vpc.cidr_block
  project         = var.project
}

locals {
  cluster_settings = {
    cluster_name            = "${var.project}-cluster"
    engine                  = "aurora-mysql"
    engine_version          = "5.7.mysql_aurora.2.10.1"
    availability_zones      = [for sb in var.db_subnets : sb.az]
    database_name           = "practice"
    master_username         = "admin"
    master_password         = "dummyPassword432"
    backup_retention_period = 5
  }
}
# bastion server(管理用サーバー)
module "bastion" {
  source              = "./modules/bastion/"
  security_group_name = "${var.project}-ve-sg"
  tags                = merge({ Name = "${var.project}-bastion" }, var.tags)
  vpc_cidr            = var.vpc.cidr_block
  vpc_id              = module.network.vpc_id
  interface_services  = var.vpc_endpoint.interface
  gateway_services    = var.vpc_endpoint.gateway
  route_table_id      = module.network.bastion_route_table_id
}
# DB
module "db" {
  source            = "./modules/db/"
  tags              = var.tags
  subnet_ids        = module.network.db_subnet_ids
  subnet_group_name = "${var.project}-subnet-group"
  cluster_settings  = local.cluster_settings
}
