provider "aws" {
  region = "ap-northeast-1"
}
# ネットワーク
module "network" {
  source   = "./modules/network/"
  tags     = var.tags
  subnets  = var.subnets
  vpc_cidr = var.vpc.cidr_block
  project  = var.project
}
