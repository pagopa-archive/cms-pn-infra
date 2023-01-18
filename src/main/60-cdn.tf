
resource "aws_cloudfront_origin_access_identity" "main" {
  comment = "Identity to access S3 bucket."
}


resource "aws_cloudfront_distribution" "media" {

  origin {
    domain_name = aws_s3_bucket.cms_media.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.cms_media.bucket

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.main.cloudfront_access_identity_path
    }
  }

  enabled         = true # enable CloudFront distribution
  is_ipv6_enabled = true
  comment         = "CloudFront distribution cms media"

  #aliases = ["${var.route53_record_name}.${var.domain_name}"]

  default_cache_behavior {
    # HTTPS requests we permit the distribution to serve
    allowed_methods  = ["GET", "HEAD", "OPTIONS", ]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.cms_media.bucket


    forwarded_values {
      query_string = false
      headers      = []
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0     # min time for objects to live in the distribution cache
    default_ttl            = 3600  # default time for objects to live in the distribution cache
    max_ttl                = 86400 # max time for objects to live in the distribution cache
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/media/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = aws_s3_bucket.cms_media.bucket

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 300
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
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

## Static website CDN
resource "aws_cloudfront_distribution" "website" {

  origin {
    domain_name = module.website_bucket.regional_domain_name
    origin_id   = module.website_bucket.name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.main.cloudfront_access_identity_path
    }
  }

  enabled             = true # enable CloudFront distribution
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for the static website."
  default_root_object = "index.html"

  aliases = (var.public_dns_zones == null || var.cloudfront_default_certificate) ? [] : [keys(var.public_dns_zones)[0], ]

  default_cache_behavior {
    # HTTPS requests we permit the distribution to serve
    allowed_methods  = ["GET", "HEAD", "OPTIONS", ]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = module.website_bucket.name


    forwarded_values {
      query_string = false
      headers      = []
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0     # min time for objects to live in the distribution cache
    default_ttl            = 3600  # default time for objects to live in the distribution cache
    max_ttl                = 86400 # max time for objects to live in the distribution cache

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.rewrite_uri.arn
    }

  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.cloudfront_default_certificate
    acm_certificate_arn            = var.cloudfront_default_certificate ? null : aws_acm_certificate.website.arn
    ssl_support_method             = "sni-only"
  }
}


// preview 
## Static website CDN
resource "aws_cloudfront_distribution" "preview" {

  origin {
    domain_name = module.preview_bucket.regional_domain_name
    origin_id   = module.preview_bucket.name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.main.cloudfront_access_identity_path
    }
  }

  enabled             = true # enable CloudFront distribution
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for the static website."
  default_root_object = "index.html"

  # aliases = var.public_dns_zones == null ? [] : [format("www.%s", keys(var.public_dns_zones)[0]), ]

  default_cache_behavior {
    # HTTPS requests we permit the distribution to serve
    allowed_methods  = ["GET", "HEAD", "OPTIONS", ]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = module.preview_bucket.name


    forwarded_values {
      query_string = false
      headers      = []
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0     # min time for objects to live in the distribution cache
    default_ttl            = 3600  # default time for objects to live in the distribution cache
    max_ttl                = 86400 # max time for objects to live in the distribution cache

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.rewrite_uri.arn
    }

  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    # acm_certificate_arn            = var.public_dns_zones != null ? aws_acm_certificate.www[0].arn : null
    # ssl_support_method = "sni-only"
  }

}
