# Cluster

locals {
  ecs_cluster_name = format("%s-ecs-cluster", local.project)

  logs = {
    name = "/ecs/strapi"
  }

  ecs_task_name = format("%s-strapi-task", local.project)
}

resource "aws_ecr_repository" "main" {
  name                 = format("%s-strapi", local.project)
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecs_cluster" "main" {
  name = local.ecs_cluster_name
  tags = { Name = local.ecs_cluster_name }
}

resource "aws_cloudwatch_log_group" "strapi" {
  name              = local.logs.name
  retention_in_days = var.logs_tasks_retention
}

# IAM
data "aws_iam_policy_document" "task_execution" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "task_execution" {
  name               = format("%s-task-execution-role", local.ecs_task_name)
  description        = format("Execution role of %s task", local.ecs_task_name)
  assume_role_policy = data.aws_iam_policy_document.task_execution.json
}

resource "aws_iam_role_policy_attachment" "task_execution" {
  role       = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "main" {
  family                   = local.ecs_task_name
  execution_role_arn       = aws_iam_role.task_execution.arn
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode([
    {
      name  = local.ecs_task_name
      image = aws_ecr_repository.main.repository_url
      environment = [
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
          value = "module.aurora_postgresql.cluster_port"
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
        }
      ]
      essential = true
      portMappings = [
        {
          containerPort = 1337
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = local.logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = local.ecs_task_name
        }
      }
    }
  ])

  lifecycle {
  }
}
