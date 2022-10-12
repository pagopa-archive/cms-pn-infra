resource "aws_cloudwatch_log_group" "gatsby" {
  name              = local.logs.name_fe
  retention_in_days = var.logs_tasks_retention
}

resource "aws_ecs_task_definition" "fe" {
  family                   = local.ecs_task_fe_name
  execution_role_arn       = aws_iam_role.task_execution.arn
  task_role_arn            = aws_iam_role.task_execution.arn
  cpu                      = 512
  memory                   = 1024
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode([
    {
      name        = local.ecs_task_fe_name
      image       = join(":", [var.ecs_fe_image, var.ecs_fe_image_version])
      environment = [],
      "cpu" : 512,
      "memory" : 1024
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

  /*
  load_balancer {
    target_group_arn = module.alb_fe.target_group_arns[0]
    container_name   = aws_ecs_task_definition.fe.family
    container_port   = local.gatsby_container_port
  }
  */

  network_configuration {
    subnets          = module.vpc.private_subnets
    assign_public_ip = false
    security_groups  = [aws_security_group.service.id]
  }
}