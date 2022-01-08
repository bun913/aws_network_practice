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
# Cloudfront
resource "aws_cloudfront_distribution" "s3_distribution" {
  for_each = { for index, b in var.bucket_list : index => b }
  enabled  = true
  origin {
    domain_name = aws_s3_bucket.origin[each.key].bucket_regional_domain_name
    origin_id   = aws_s3_bucket.origin[each.key].id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai[each.value.bucket_name].cloudfront_access_identity_path
    }
  }
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.origin[each.key].id
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["JP"]
    }
  }
  viewer_certificate {
    # NOTE: 今回は手動でSSL証明書を検証する作業と紐づける作業が必要という前提
    cloudfront_default_certificate = true
  }
}
