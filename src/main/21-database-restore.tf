resource "random_string" "db_suffix" {
  count   = var.db_snapshot_identifier != null ? 1 : 0
  length  = 3
  special = false
  upper   = false
}

module "aurora_postgresql_restore" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.3.0"
  count   = var.db_snapshot_identifier != null ? 1 : 0

  name                   = format("%s-postgresql-%s", local.project, random_string.db_suffix[0].id)
  engine                 = data.aws_rds_engine_version.postgresql.engine
  engine_mode            = "provisioned"
  engine_version         = data.aws_rds_engine_version.postgresql.version
  storage_encrypted      = true
  master_username        = "cmsuser"
  database_name          = "cms"
  create_random_password = true
  random_password_length = 16

  vpc_id                = module.vpc.vpc_id
  subnets               = module.vpc.database_subnets
  create_security_group = true
  allowed_cidr_blocks   = module.vpc.private_subnets_cidr_blocks

  monitoring_interval = 60

  apply_immediately   = true
  skip_final_snapshot = true

  db_parameter_group_name         = aws_db_parameter_group.postgresql14.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.postgresql14.id

  # Serverless instance class is not available in Milan.
  serverlessv2_scaling_configuration = {
    min_capacity = 2
    max_capacity = 10
  }

  instance_class = "db.serverless"

  snapshot_identifier = var.db_snapshot_identifier

  backup_retention_period = var.db_backup_retention_period
  preferred_backup_window = var.db_preferred_backup_window

  instances = {
    one = {}
  }
}