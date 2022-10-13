env_short   = "d"
environment = "dev"
aws_region  = "eu-south-1"

# Notifiche digitali.
app_name = "pn"

enable_nat_gateway         = true
ecs_enable_execute_command = true
ecs_cms_image_version      = "v1.0.0"
ecs_fe_image_version       = "v1.0.0"

# Ref: https://pagopa.atlassian.net/wiki/spaces/DEVOPS/pages/132810155/Azure+-+Naming+Tagging+Convention#Tagging
tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "Frontend Web Notifiche digitali."
  Source      = "https://github.com/pagopa/cms-pn-infra"
  CostCenter  = "TS310 - PAGAMENTI e SERVIZI"
}