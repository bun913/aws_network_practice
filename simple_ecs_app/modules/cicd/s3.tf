# パイプライン保存用
resource "aws_s3_bucket" "pipeline" {
  bucket = "${var.project}-deploy-pipeline"
  acl    = "private"
}
