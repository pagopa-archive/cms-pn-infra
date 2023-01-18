env_short   = "p"
environment = "prod"
aws_region  = "eu-central-1"

app_name = "cms"

enable_nat_gateway         = true
ecs_enable_execute_command = true
ecs_cms_image_version      = "v1.1.0"
ecs_fe_image_version       = "v1.0.0" # Frontend preview.

public_dns_zones = {
  "notifichedigitali.pagopa.it" = {
    comment = "Notifiche digitali public dns zone DEV."
  }
}


pn_dns_records = [
  {
    name  = "_8a1175b1ab47d8bf7c3224ccc1394c03"
    value = "_95894bfe02d574080589d54595887a8f.dhzvlrndnj.acm-validations.aws"
    type  = "CNAME"
  },
  {
    name  = "testdns"
    value = "Test TXT Record for DNS zone notifichedigitali.pagopa.it"
    type  = "TXT"
  },
]

create_cert_validation_records = false
cloudfront_default_certificate = true

# Ref: https://pagopa.atlassian.net/wiki/spaces/DEVOPS/pages/132810155/Azure+-+Naming+Tagging+Convention#Tagging
tags = {
  CreatedBy   = "Terraform"
  Environment = "Prod"
  Owner       = "Frontend Web"
  Source      = "https://github.com/pagopa/cms-infra"
  CostCenter  = "TS310 - PAGAMENTI e SERVIZI"
}