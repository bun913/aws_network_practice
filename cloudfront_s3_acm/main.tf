# HACK: tfvarsに定義しても良い
locals {
  webassets = [
    {
      "bucket_name" : "acm-practice-1",
      "acl" : "private"
    },
    {
      "bucket_name" : "acm-practice-2",
      "acl" : "private"
    }
  ]
}
module "webassets" {
  source      = "./modules/webassets/"
  tags        = var.tags
  bucket_list = local.webassets
}
