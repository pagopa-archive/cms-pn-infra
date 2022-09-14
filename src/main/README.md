## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.12.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.12.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | terraform-aws-modules/alb/aws |  |
| <a name="module_aurora_postgresql"></a> [aurora\_postgresql](#module\_aurora\_postgresql) | terraform-aws-modules/rds-aurora/aws | 7.3.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 3.14.2 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_identity.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |
| [aws_cloudwatch_log_group.strapi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_parameter_group.postgresql14](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_ecr_repository.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecs_cluster.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_access_key.strapi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_policy.upload_image](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.strapi-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.task_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.task_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user.strapi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_rds_cluster_parameter_group.postgresql14](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [aws_s3_bucket.images](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.cloudfront](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.terraform_states](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_versioning.terraform_states](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_integer.bucket_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy.admin_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.task_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_rds_engine_version.postgresql](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/rds_engine_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ecs_cms_image_version"></a> [ecs\_cms\_image\_version](#input\_ecs\_cms\_image\_version) | Cms image to deploy | `string` | n/a | yes |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | App name. Personal Data Vault | `string` | `"pdv"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to create resources. Default Milan | `string` | `"eu-south-1"` | no |
| <a name="input_dns_record_ttl"></a> [dns\_record\_ttl](#input\_dns\_record\_ttl) | Dns record ttl (in sec) | `number` | `86400` | no |
| <a name="input_ecs_enable_execute_command"></a> [ecs\_enable\_execute\_command](#input\_ecs\_enable\_execute\_command) | Enable to execute command inside ECS container for debugging. | `bool` | `false` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Enable/Create nat gateway | `bool` | `false` | no |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | Evnironment short. | `string` | `"d"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | `"dev"` | no |
| <a name="input_logs_tasks_retention"></a> [logs\_tasks\_retention](#input\_logs\_tasks\_retention) | Days to retain a log stream. | `number` | `7` | no |
| <a name="input_public_dns_zones"></a> [public\_dns\_zones](#input\_public\_dns\_zones) | Route53 Hosted Zone | `map(any)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC cidr. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_database_subnets_cidr"></a> [vpc\_database\_subnets\_cidr](#input\_vpc\_database\_subnets\_cidr) | Internal subnets list of cidr. Mainly for private endpoints | `list(string)` | <pre>[<br>  "10.0.201.0/24",<br>  "10.0.202.0/24",<br>  "10.0.203.0/24"<br>]</pre> | no |
| <a name="input_vpc_private_subnets_cidr"></a> [vpc\_private\_subnets\_cidr](#input\_vpc\_private\_subnets\_cidr) | Private subnets list of cidr. | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_vpc_public_subnets_cidr"></a> [vpc\_public\_subnets\_cidr](#input\_vpc\_public\_subnets\_cidr) | Private subnets list of cidr. | `list(string)` | <pre>[<br>  "10.0.101.0/24",<br>  "10.0.102.0/24",<br>  "10.0.103.0/24"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | # Alb |
| <a name="output_cdn_domain_name"></a> [cdn\_domain\_name](#output\_cdn\_domain\_name) | # CDN |
| <a name="output_db_cluster_database_name"></a> [db\_cluster\_database\_name](#output\_db\_cluster\_database\_name) | # Database |
| <a name="output_db_cluster_endpoint"></a> [db\_cluster\_endpoint](#output\_db\_cluster\_endpoint) | n/a |
| <a name="output_db_cluster_master_password"></a> [db\_cluster\_master\_password](#output\_db\_cluster\_master\_password) | n/a |
| <a name="output_db_cluster_master_username"></a> [db\_cluster\_master\_username](#output\_db\_cluster\_master\_username) | n/a |
| <a name="output_db_cluster_port"></a> [db\_cluster\_port](#output\_db\_cluster\_port) | n/a |
| <a name="output_image_s3_bucket"></a> [image\_s3\_bucket](#output\_image\_s3\_bucket) | # Storage |
| <a name="output_image_s3_domain"></a> [image\_s3\_domain](#output\_image\_s3\_domain) | n/a |
| <a name="output_strapi_user_access_key"></a> [strapi\_user\_access\_key](#output\_strapi\_user\_access\_key) | # Iam |
| <a name="output_strapi_user_secret_key"></a> [strapi\_user\_secret\_key](#output\_strapi\_user\_secret\_key) | n/a |
| <a name="output_vpc_cidr"></a> [vpc\_cidr](#output\_vpc\_cidr) | Network |
