provider "aws" {
  region = "ap-northeast-1"
}

module "network" {
  source          = "./modules/network/"
  vpc_cidr        = var.vpc.cidr_block
  private_subnets = var.private_subnets
  alb_subnets     = var.alb_subnets
  db_subnets      = var.db_subnets
  project         = var.project

  tags = var.tags
}

module "web_app" {
  source = "./modules/web_app/"

  project     = var.project
  alb_name    = "${var.project}-internal-lb"
  vpc_id      = module.network.vpc_id
  alb_subnets = module.network.alb_subnet_ids

  vpc_cidr               = var.vpc.cidr_block
  private_subnets        = module.network.private_subnet_ids
  private_route_table_id = module.network.private_route_table_id
  interface_services     = var.vpc_endpoint.interface
  gateway_services       = var.vpc_endpoint.gateway

  region = var.region

  tags = var.tags
}

# DB
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
module "db" {
  source            = "./modules/db/"
  project           = var.project
  vpc_id            = module.network.vpc_id
  tags              = var.tags
  subnet_ids        = module.network.db_subnet_ids
  subnet_group_name = "${var.project}-subnet-group"
  sg_group_name     = "${var.project}-sg-group"
  cluster_settings  = local.cluster_settings
  allow_sg_ids      = [module.web_app.ecs_service_sg_id]
}
