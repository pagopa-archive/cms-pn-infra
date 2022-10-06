env_short   = "p"
environment = "prod"
aws_region  = "eu-central-1"

app_name = "cms"

enable_nat_gateway         = true
ecs_enable_execute_command = true
ecs_cms_image_version      = "36.0"

# Ref: https://pagopa.atlassian.net/wiki/spaces/DEVOPS/pages/132810155/Azure+-+Naming+Tagging+Convention#Tagging
tags = {
  CreatedBy   = "Terraform"
  Environment = "Prod"
  Owner       = "Frontend Web"
  Source      = "https://github.com/pagopa/cms-infra"
  CostCenter  = "TS310 - PAGAMENTI e SERVIZI"
}