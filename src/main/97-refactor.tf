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