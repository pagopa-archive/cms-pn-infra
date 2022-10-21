resource "aws_cloudwatch_log_group" "gatsby" {
  name              = local.logs.name_fe
  retention_in_days = var.logs_tasks_retention
}

# ecs role

resource "aws_iam_role" "task_fe_execution" {
  name               = "EcsTaskFeExecutionRole"
  description        = format("Execution role of %s task", local.ecs_task_fe_name)
  assume_role_policy = data.aws_iam_policy_document.task_execution.json
  tags               = { Name = format("%s-execution-task-role", local.project) }
}

resource "aws_iam_role_policy_attachment" "task_fe_execution" {
  role       = aws_iam_role.task_fe_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

## secret policy
resource "aws_iam_policy" "task_fe_secretmanager" {
  name        = "ECSFEGetSecrets"
  path        = "/"
  description = "Policy to allow to access to required secrets."

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "kms:Decrypt"
        ],
        "Resource" : [
          "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:${local.secret_strapi}*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "task_fe_secret" {
  role       = aws_iam_role.task_fe_execution.name
  policy_arn = aws_iam_policy.task_fe_secretmanager.arn
}

resource "aws_ecs_task_definition" "fe" {
  family                   = local.ecs_task_fe_name
  execution_role_arn       = aws_iam_role.task_fe_execution.arn
  task_role_arn            = aws_iam_role.task_fe_execution.arn
  cpu                      = 1024
  memory                   = 4096
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode([
    {
      name  = local.ecs_task_fe_name
      image = join(":", [var.ecs_fe_image, var.ecs_fe_image_version])
      secrets = [
        {
          name      = "STRAPI_TOKEN",
          valueFrom = "${data.aws_secretsmanager_secret.strapi.arn}:STRAPI_TOKEN::"
        }
      ]
      environment = [
        {
          name  = "STRAPI_API_URL"
          value = format("https://%s", aws_route53_record.cms.fqdn)
        }
      ]
      "cpu" : 1024,
      "memory" : 4096
      essential = true
      portMappings = [
        {
          containerPort = local.gatsby_container_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.gatsby.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = local.ecs_task_fe_name
        }
      }
    }
  ])

  lifecycle {
  }
}

## Service
resource "aws_ecs_service" "fe" {
  name                   = format("%s-gatsby-srv", local.project)
  cluster                = aws_ecs_cluster.main.id
  task_definition        = aws_ecs_task_definition.fe.arn
  launch_type            = "FARGATE"
  desired_count          = 1
  enable_execute_command = var.ecs_enable_execute_command

  load_balancer {
    target_group_arn = module.alb_fe.target_group_arns[0]
    container_name   = aws_ecs_task_definition.fe.family
    container_port   = local.gatsby_container_port
  }

  network_configuration {
    subnets          = module.vpc.private_subnets
    assign_public_ip = false
    security_groups  = [aws_security_group.service.id]
  }
}