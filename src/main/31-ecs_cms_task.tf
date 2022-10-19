# ECS Cms task
resource "aws_cloudwatch_log_group" "strapi" {
  name              = local.logs.name_cms
  retention_in_days = var.logs_tasks_retention
}

resource "random_string" "cms_api_keys" {
  count   = 2
  length  = 7
  special = false
  lower   = false
}

resource "random_string" "cms_api_token_salt" {
  length  = 12
  special = false
  lower   = false
}

resource "random_string" "jwt_secrets" {
  count   = 2
  length  = 12
  special = false
  lower   = false
}

resource "aws_ecs_task_definition" "cms" {
  family                   = local.ecs_task_cms_name
  execution_role_arn       = aws_iam_role.task_execution.arn
  task_role_arn            = aws_iam_role.task_execution.arn
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode([
    {
      name  = local.ecs_task_cms_name
      image = join(":", [var.ecs_cms_image, var.ecs_cms_image_version])
      environment = [
        {
          name  = "APP_KEYS"
          value = join(", ", random_string.cms_api_keys.*.result)
        },
        {
          name  = "API_TOKEN_SALT"
          value = random_string.cms_api_token_salt.result
        },
        {
          name  = "ADMIN_JWT_SECRET"
          value = random_string.jwt_secrets[0].result
        },
        {
          name  = "JWT_SECRET"
          value = random_string.jwt_secrets[1].result
        },
        {
          name  = "DATABASE_CLIENT"
          value = "postgres"
        },
        {
          name  = "DATABASE_HOST"
          value = module.aurora_postgresql.cluster_endpoint
        },
        {
          name  = "DATABASE_PORT"
          value = "5432"
        },
        {
          name  = "DATABASE_NAME"
          value = module.aurora_postgresql.cluster_database_name
        },
        {
          name  = "DATABASE_USERNAME"
          value = module.aurora_postgresql.cluster_master_username
        },
        {
          name  = "DATABASE_PASSWORD"
          value = module.aurora_postgresql.cluster_master_password
        },
        {
          name  = "DATABASE_SSL"
          value = "false"
        },
        {
          name  = "AWS_ACCESS_KEY_ID"
          value = aws_iam_access_key.strapi.id
        },
        {
          name  = "AWS_ACCESS_SECRET"
          value = aws_iam_access_key.strapi.secret
        },
        {
          name  = "AWS_BUCKET_NAME"
          value = aws_s3_bucket.images.id
        },
        {
          name  = "AWS_REGION"
          value = var.aws_region
        },
        {
          name  = "CDN_BASE_URL"
          value = format("https://%s", aws_cloudfront_distribution.alb.domain_name)
        },
        {
          name  = "BUCKET_PREFIX"
          value = "media"
        },
        {
          name  = "GOOGLE_OAUTH_CLIENT_ID"
          value = jsondecode(data.aws_secretsmanager_secret_version.google_oauth.secret_string)["GOOGLE_OAUTH_CLIENT_ID"]
        },
        { name  = "GOOGLE_OAUTH_CLIENT_SECRET"
          value = jsondecode(data.aws_secretsmanager_secret_version.google_oauth.secret_string)["GOOGLE_OAUTH_CLIENT_SECRET"]
        },
        {
          name  = "GOOGLE_OAUTH_REDIRECT_URI"
          value = jsondecode(data.aws_secretsmanager_secret_version.google_oauth.secret_string)["GOOGLE_OAUTH_REDIRECT_URI"]
        }
      ],
      "cpu" : 256,
      "memory" : 512
      essential = true
      portMappings = [
        {
          containerPort = local.strapi_container_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.strapi.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = local.ecs_task_cms_name
        }
      }
    }
  ])

  lifecycle {
  }
}

resource "aws_security_group" "service" {

  name = "ECS Service Security group."

  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Only allowing traffic in from the load balancer security group
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0             # Allowing any incoming port
    to_port     = 0             # Allowing any outgoing port
    protocol    = "-1"          # Allowing any outgoing protocol 
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}

## Service
resource "aws_ecs_service" "cms" {
  name                   = format("%s-strapi-srv", local.project)
  cluster                = aws_ecs_cluster.main.id
  task_definition        = aws_ecs_task_definition.cms.arn
  launch_type            = "FARGATE"
  desired_count          = 1
  enable_execute_command = var.ecs_enable_execute_command

  load_balancer {
    target_group_arn = module.alb_cms.target_group_arns[0]
    container_name   = aws_ecs_task_definition.cms.family
    container_port   = local.strapi_container_port
  }

  network_configuration {
    subnets          = module.vpc.private_subnets
    assign_public_ip = false
    security_groups  = [aws_security_group.service.id]
  }

}
