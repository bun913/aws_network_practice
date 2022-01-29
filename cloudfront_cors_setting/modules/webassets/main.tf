# oai
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "${var.project}-oai"
}
# create bucket
resource "aws_s3_bucket" "origin" {
  bucket = "${var.project}-origin"
  acl    = "private"
  policy = templatefile(
    "${path.module}/policy.json",
    {
      oai_arn     = aws_cloudfront_origin_access_identity.oai.id
      bucket_name = "${var.project}-origin"
    }
  )

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = var.allowed_origins
    expose_headers  = []
    max_age_seconds = 3000
  }

  tags = var.tags
}

# キャッシュポリシー
data "aws_cloudfront_cache_policy" "asset" {
  name = "Managed-Elemental-MediaPackage"
}
# オリジンリクエストポリシー
data "aws_cloudfront_origin_request_policy" "asset" {
  name = "Managed-CORS-S3Origin"
}
# レスポンスヘッダーポリシー
resource "aws_cloudfront_response_headers_policy" "asset" {
  name    = "${var.project}-response-headers-policy"
  comment = "Allow from limited origins"

  cors_config {
    access_control_allow_credentials = false

    access_control_allow_headers {
      items = ["*"]
    }

    access_control_allow_methods {
      items = ["GET", "HEAD"]
    }

    access_control_allow_origins {
      items = var.allowed_origins
    }

    origin_override = true
  }
}

# Cloudfront
resource "aws_cloudfront_distribution" "asset" {
  enabled = true
  origin {
    domain_name = aws_s3_bucket.origin.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.origin.id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.origin.id
    viewer_protocol_policy = "allow-all"

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400

    # 3つのポリシーを適用
    cache_policy_id            = data.aws_cloudfront_cache_policy.asset.id
    origin_request_policy_id   = data.aws_cloudfront_origin_request_policy.asset.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.asset.id
  }
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["JP"]
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
