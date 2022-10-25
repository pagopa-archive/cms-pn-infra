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


/*
## Preview load balancer
resource "aws_route53_record" "preview" {
  zone_id = module.dns_zone.route53_zone_zone_id[keys(var.public_dns_zones)[0]]
  name    = "preview"
  type    = "CNAME"
  records = [module.alb_fe.lb_dns_name]
  ttl     = var.dns_record_ttl
}

*/