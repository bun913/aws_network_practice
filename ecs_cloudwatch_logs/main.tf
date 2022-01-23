provider "aws" {
  region = "ap-northeast-1"
}

module "network" {
  source          = "./modules/network/"
  vpc_cidr        = var.vpc.cidr_block
  private_subnets = var.private_subnets
  alb_subnets     = var.alb_subnets
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
