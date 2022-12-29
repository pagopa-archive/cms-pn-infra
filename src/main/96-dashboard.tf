resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = format("pn-%s-dashboard-v1", var.env_short)

  dashboard_body = templatefile("${path.module}/dashboards/main.json",
    {
      aws_region              = var.aws_region
      cf_distribution_id      = aws_cloudfront_distribution.website.id,
      ecs_cluster_name        = aws_ecs_cluster.main.name
      ecs_cms_service_name    = aws_ecs_service.cms.name,
      rds_aurora_cluster_name = module.aurora_postgresql.cluster_id,
      alb_fe_arn_suffix       = try(module.alb_fe[0].lb_arn_suffix, ""),
    }
  )
}