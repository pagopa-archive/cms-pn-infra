resource "aws_cloudfront_origin_access_identity" "main" {
  comment = "Some comment"
}


resource "aws_cloudfront_distribution" "images" {

  origin {
    domain_name = format("%s.s3.amazonaws.com", aws_s3_bucket.images.bucket)
    origin_id   = aws_s3_bucket.images.bucket

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.main.cloudfront_access_identity_path
    }
  }

  enabled         = true # enable CloudFront distribution
  is_ipv6_enabled = true
  comment         = "CloudFront distribution for serving images."

  #aliases = ["${var.route53_record_name}.${var.domain_name}"]

  default_cache_behavior {
    # HTTPS requests we permit the distribution to serve
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.images.bucket

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0     # min time for objects to live in the distribution cache
    default_ttl            = 3600  # default time for objects to live in the distribution cache
    max_ttl                = 86400 # max time for objects to live in the distribution cache
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true # use this if you don't have certificate
    # acm_certificate_arn = aws_acm_certificate.cloudfront_cdn.arn
    # ssl_support_method = "sni-only"
  }


  # depends_on = [aws_acm_certificate.cloudfront_cdn]
}