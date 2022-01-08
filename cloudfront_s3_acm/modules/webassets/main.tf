# oai
resource "aws_cloudfront_origin_access_identity" "oai" {
  for_each = { for b in var.bucket_list : b.bucket_name => b }
  comment  = "${each.key}-oai"
}
# create bucket
resource "aws_s3_bucket" "origin" {
  for_each = { for index, b in var.bucket_list : index => b }
  bucket   = each.value.bucket_name
  acl      = each.value.acl
  policy = templatefile(
    "${path.module}/policy.json",
    {
      oai_arn     = aws_cloudfront_origin_access_identity.oai[each.value.bucket_name].id
      bucket_name = each.value.bucket_name
    }
  )

  tags = var.tags
}
