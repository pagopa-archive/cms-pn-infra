terraform {
  required_version = "~> 1.2.0"

  # TODO Uncomment once the backend S3 bucket is created and upload the state tate file.
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.12.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = var.tags
  }
}


data "aws_caller_identity" "current" {}