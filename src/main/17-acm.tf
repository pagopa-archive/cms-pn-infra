# TLS Certificates

resource "aws_acm_certificate" "preview" {
  domain_name       = aws_route53_record.preview.fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "cms" {
  domain_name       = aws_route53_record.cms.fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  cert_domain_validation_options = [aws_acm_certificate.preview.domain_validation_options,
  aws_acm_certificate.cms.domain_validation_options]


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
  zone_id         = module.dns_zone.route53_zone_zone_id[keys(var.public_dns_zones)[0]]
}

