locals {
  project = format("%s-%s", var.app_name, var.env_short)

  ecs_cluster_name = format("%s-ecs-cluster", local.project)
  ecs_task_name    = format("%s-strapi-task", local.project)

  logs = {
    name = "/ecs/strapi"
  }

}