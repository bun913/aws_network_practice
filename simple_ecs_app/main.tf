provider "aws" {
  region = "ap-northeast-1"
}

module "network" {
  source   = "./modules/network/"
  vpc_cidr = var.vpc.cidr_block

  private_subnets = var.private_subnets
  alb_subnets     = var.alb_subnets
  project         = var.project

  tags = var.tags
}

module "web_app" {
  source      = "./modules/web_app/"
  alb_name    = "${var.project}-internal-lb"
  vpc_id      = module.network.vpc_id
  alb_subnets = module.network.alb_subnet_ids

  tags = var.tags
}
