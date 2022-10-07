variable "aws_region" {
  type        = string
  description = "AWS region (default is Milan)"
  default     = "eu-south-1"
}

variable "environment" {
  type        = string
  description = "Environment. Possible values are: Dev, Uat, Prod"
  default     = "Uat"
}

variable "github_repository" {
  type        = string
  description = "Github repository in the format organization/repository"
  default     = "pagopa/cms-pn-infra"
}


variable "tags" {
  type = map(any)
  default = {
    "CreatedBy" : "Terraform",
    "Environment" : "Uat"
  }
}