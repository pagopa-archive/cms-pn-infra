data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

# Creating a security group for the load balancer:
resource "aws_security_group" "alb" {

  name = "Alb Security group"

  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 80 # Allowing traffic in from port 80
    to_port   = 80
    protocol  = "tcp"
    #cidr_blocks = ["0.0.0.0/0"] # Allowing traffic in from all sources
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.cloudfront.id]
  }

  egress {
    from_port   = 0             # Allowing any incoming port
    to_port     = 0             # Allowing any outgoing port
    protocol    = "-1"          # Allowing any outgoing protocol 
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}


module "alb_cms" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.0"

  name = format("%s-alb", local.project)

  load_balancer_type = "application"

  security_groups = [aws_security_group.alb.id]

  vpc_id                           = module.vpc.vpc_id
  subnets                          = module.vpc.public_subnets
  enable_cross_zone_load_balancing = "true"

  internal = false

  http_tcp_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      target_group_index = 0
    },
  ]


  target_groups = [
    {
      # service streapi
      name                 = format("%s-strapi", local.project)
      backend_protocol     = "HTTP"
      backend_port         = local.strapi_container_port
      target_type          = "ip"
      deregistration_delay = 30
      vpc_id               = module.vpc.vpc_id
      health_check = {
        enabled = true

        healthy_threshold   = 3
        interval            = 30
        timeout             = 6
        unhealthy_threshold = 3
        matcher             = "200-399"
        path                = "/"
      }
    },
  ]

  tags = { Name : format("%s-alb", local.project) }
}