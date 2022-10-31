# DNS Zone
module "dns_zone" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"

  zones = var.public_dns_zones
}

resource "aws_route53_record" "cms" {
  zone_id = module.dns_zone.route53_zone_zone_id[keys(var.public_dns_zones)[0]]
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

## Public website
resource "aws_route53_record" "website" {
  zone_id = module.dns_zone.route53_zone_zone_id[keys(var.public_dns_zones)[0]]
  name    = ""
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}