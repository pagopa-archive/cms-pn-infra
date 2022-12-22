# TLS Certificates
resource "aws_acm_certificate" "website" {
  count             = var.public_dns_zones == null ? 0 : 1
  domain_name       = keys(var.public_dns_zones)[0]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "cms" {
  count             = var.public_dns_zones == null ? 0 : 1
  domain_name       = aws_route53_record.cms[0].fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "www" {
  count = var.public_dns_zones == null ? 0 : 1
  # domain_name       =  aws_route53_record.www[0].fqdn this is a cycle and it's not gonna to work.                  
  domain_name       = format("www.%s", keys(var.public_dns_zones)[0])
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  provider = aws.us-east-1
}

locals {
  cert_domain_validation_options = var.public_dns_zones != null ? [
    aws_acm_certificate.cms[0].domain_validation_options,
    aws_acm_certificate.website[0].domain_validation_options,
    aws_acm_certificate.www[0].domain_validation_options,
  ] : []
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in local.cert_domain_validation_options : tolist(dvo)[0].domain_name => {
      name   = tolist(dvo)[0].resource_record_name
      record = tolist(dvo)[0].resource_record_value
      type   = tolist(dvo)[0].resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 3600 # 1h
  type            = each.value.type
  zone_id         = module.dns_zone[0].route53_zone_zone_id[keys(var.public_dns_zones)[0]]
  depends_on = [
    aws_acm_certificate.cms,
    aws_acm_certificate.website,
    aws_acm_certificate.www,
  ]
}
