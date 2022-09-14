
resource "aws_cloudfront_origin_access_identity" "main" {
  comment = "Some comment"
}


resource "aws_cloudfront_distribution" "alb" {

  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = module.alb.lb_dns_name
    origin_id           = split(".", module.alb.lb_dns_name)[0]
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }

  enabled         = true # enable CloudFront distribution
  is_ipv6_enabled = true
  comment         = "CloudFront distribution Alb target."

  #aliases = ["${var.route53_record_name}.${var.domain_name}"]

  default_cache_behavior {
    # HTTPS requests we permit the distribution to serve
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = split(".", module.alb.lb_dns_name)[0]


    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }

      headers = ["*"]
    }

    viewer_protocol_policy = "redirect-to-https"
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