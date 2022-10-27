## Iam
output "strapi_user_access_key" {
  value = aws_iam_access_key.strapi.id
}

output "strapi_user_secret_key" {
  value     = aws_iam_access_key.strapi.secret
  sensitive = true
}

output "deploy_ecs_role_arn" {
  value = aws_iam_role.deploy_ecs.arn
}

output "deploy_website_role_arn" {
  value = aws_iam_role.deploy_website.arn
}

# Network
output "vpc_cidr" {
  value = module.vpc.vpc_cidr_block
}

# DNS Zone
output "public_dns_zone_name" {
  value = module.dns_zone.route53_zone_name
}

output "public_dns_servers" {
  value = module.dns_zone.route53_zone_name_servers
}

/*
output "preview_fqdn" {
  value = aws_route53_record.preview.fqdn
}
*/

output "cms_fqdn" {
  value = aws_route53_record.cms.fqdn
}

## Database
output "db_cluster_database_name" {
  value = module.aurora_postgresql.cluster_database_name
}

output "db_cluster_endpoint" {
  value = module.aurora_postgresql.cluster_endpoint
}

output "db_cluster_port" {
  value = module.aurora_postgresql.cluster_port
}

output "db_cluster_master_username" {
  value     = module.aurora_postgresql.cluster_master_username
  sensitive = true
}

output "db_cluster_master_password" {
  value     = module.aurora_postgresql.cluster_master_password
  sensitive = true
}


## Alb
output "alb_cms_dns_name" {
  value = module.alb_cms.lb_dns_name
}

/*
output "alb_fe_dns_name" {
  value       = module.alb_fe.lb_dns_name
  description = "Preview frontend."
}
*/

## Storage
output "image_s3_bucket" {
  value = aws_s3_bucket.cms_media.bucket
}

output "website_s3_bucket" {
  value = module.website_bucket
}

## CDN
output "cdn_media_domain_name" {
  value = aws_cloudfront_distribution.media.domain_name
}

output "cdn_website_domain_name" {
  value = aws_cloudfront_distribution.website.domain_name
}