provider "aws" {
  region = "ap-northeast-1"
}

module "webassets" {
  source          = "./modules/webassets/"
  project         = var.project
  allowed_origins = ["https://hoge.com", "https://fuga.com"]
  tags            = var.tags
}
