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

  container_image_url = "${var.ecr_repo}:v1"
  region              = var.region

  tags = var.tags
}

module "cicd" {
  source = "./modules/cicd/"

  project  = var.project
  region   = var.region
  ecr_repo = var.ecr_repo

  cluster_name           = module.web_app.cluster_name
  service_name           = module.web_app.service_name
  blue_listner_arn       = module.web_app.blue_listener_arn
  green_listner_arn      = module.web_app.green_listener_arn
  blue_targetgroup_name  = module.web_app.blue_targetgroup_name
  green_targetgroup_name = module.web_app.green_targetgroup_name
}
