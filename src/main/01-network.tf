module "vpc" {
  source                = "terraform-aws-modules/vpc/aws"
  version               = "3.14.2"
  name                  = format("%s-vpc", local.project)
  cidr                  = var.vpc_cidr
  azs                   = var.azs
  private_subnets       = var.vpc_private_subnets_cidr
  private_subnet_suffix = "private"
  public_subnets        = var.vpc_public_subnets_cidr
  public_subnet_suffix  = "public"
  database_subnets      = var.vpc_database_subnets_cidr
  enable_nat_gateway    = var.enable_nat_gateway

  enable_dns_hostnames = true
  enable_dns_support   = true

}