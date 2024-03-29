moved {
  from = aws_ecs_cluster.ecs_cluster
  to   = aws_ecs_cluster.main
}

moved {
  from = aws_ecs_task_definition.main
  to   = aws_ecs_task_definition.cms
}

moved {
  from = aws_ecs_service.main
  to   = aws_ecs_service.cms
}

moved {
  from = module.alb
  to   = module.alb_cms
}

moved {
  from = module.dn_zone
  to   = module.dns_zone
}

moved {
  from = aws_s3_bucket_versioning.terraform_states
  to   = aws_s3_bucket_versioning.cms_media
}

moved {
  from = random_integer.bucket_suffix
  to   = random_integer.bucket_cms_media
}

moved {
  from = aws_s3_bucket.images
  to   = aws_s3_bucket.cms_media
}

moved {
  from = aws_iam_policy_document.s3_policy
  to   = aws_iam_policy_document.s3_policy_media
}

moved {
  from = aws_cloudfront_distribution.alb
  to   = aws_cloudfront_distribution.media
}

moved {
  from = module.eventbridge
  to   = module.eventbridge[0]
}