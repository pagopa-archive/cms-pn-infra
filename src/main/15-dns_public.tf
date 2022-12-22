# DNS Zone
module "dns_zone" {
  count   = var.public_dns_zones == null ? 0 : 1
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"

  zones = var.public_dns_zones
}

resource "aws_route53_record" "cms" {
  count   = var.public_dns_zones == null ? 0 : 1
  zone_id = module.dns_zone[0].route53_zone_zone_id[keys(var.public_dns_zones)[0]]
  name    = "cms"
  type    = "CNAME"
  records = [module.alb_cms.lb_dns_name]
  ttl     = var.dns_record_ttl
}


## Preview website
/*
resource "aws_route53_record" "preview" {
  zone_id = module.dns_zone.route53_zone_zone_id[keys(var.public_dns_zones)[0]]
  name    = "preview"
  type    = "CNAME"
  records = [aws_cloudfront_distribution.preview.domain_name]
  ttl     = var.dns_record_ttl
}
*/

## Public website (apex record.)
resource "aws_route53_record" "website" {
  count   = var.public_dns_zones == null ? 0 : 1
  zone_id = module.dns_zone[0].route53_zone_zone_id[keys(var.public_dns_zones)[0]]
  name    = ""
  type    = "A"
  records = aws_globalaccelerator_accelerator.alb_fe_ga[0].ip_sets[0].ip_addresses

  ttl = var.dns_record_ttl
}

resource "aws_route53_record" "www" {
  count   = var.public_dns_zones == null ? 0 : 1
  zone_id = module.dns_zone[0].route53_zone_zone_id[keys(var.public_dns_zones)[0]]
  name    = "www"
  type    = "CNAME"
  ttl     = var.dns_record_ttl

  weighted_routing_policy {
    weight = 90
  }

  set_identifier = "live"
  records        = [aws_cloudfront_distribution.website.domain_name]
}