env_short   = "d"
environment = "dev"
aws_region  = "eu-central-1"

# Notifiche digitali.
app_name = "pn"


public_dns_zones = {
  "poc.pn.pagopa.it" = {
    comment = "Notifiche digitali public dns zone DEV."
  }
}


dns_record_ttl = 300 # 5 min

enable_nat_gateway         = true
ecs_enable_execute_command = true
ecs_cms_image_version      = "latest"

# Rds Aurora.
db_backup_retention_period = 3
db_stop_enable             = true

# Ref: https://pagopa.atlassian.net/wiki/spaces/DEVOPS/pages/132810155/Azure+-+Naming+Tagging+Convention#Tagging
tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "Frontend Web Notifiche digitali."
  Source      = "https://github.com/pagopa/cms-pn-infra"
  CostCenter  = "TS310 - PAGAMENTI e SERVIZI"
}
