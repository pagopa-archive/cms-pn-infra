# Network
output "vpc_cidr" {
  value = module.vpc.vpc_cidr_block
}


## Database
output "cluster_database_name" {
  value = module.aurora_postgresql.cluster_database_name
}

output "cluster_endpoint" {
  value = module.aurora_postgresql.cluster_endpoint
}

output "cluster_port" {
  value = module.aurora_postgresql.cluster_port
}

output "db_instance_username" {
  value = module.aurora_postgresql.db_instance_userna
}

output "db_instance_password" {
  value = module.aurora_postgresql.db_instance_password
}