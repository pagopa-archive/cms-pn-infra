locals {
  project = format("%s-%s", var.app_name, var.env_short)

  ecs_cluster_name  = format("%s-ecs-cluster", local.project)
  ecs_task_cms_name = format("%s-strapi-task", local.project)
  ecs_task_fe_name  = format("%s-gatsby-task", local.project)

  strapi_container_port = 1337
  gatsby_container_port = 8000

  logs = {
    name_cms = "/ecs/strapi"
    name_fe  = "/ecs/gatsby"
  }

}