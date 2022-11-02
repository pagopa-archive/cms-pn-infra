locals {
  project = format("%s-%s", var.app_name, var.env_short)

  ecs_cluster_name  = format("%s-ecs-cluster", local.project)
  ecs_task_cms_name = format("%s-strapi-task", local.project)

  strapi_container_port = 1337

  secret_google_oauth = "google/oauth"
  secret_strapi       = "strapi"
  secret_github       = "github"

  logs = {
    name_cms = "/ecs/strapi"
    name_fe  = "/ecs/gatsby"
  }

  cname_cms     = "cms"
  cname_preview = "preview"
}