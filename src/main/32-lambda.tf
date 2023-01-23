resource "aws_cloudfront_function" "rewrite_uri" {
  name    = "rewrite-request"
  runtime = "cloudfront-js-1.0"
  publish = true

  code = <<EOF
function handler(event) {
    var request = event.request;
    var uri = request.uri;
    
    // Check whether the URI is missing a file name.
    if (uri.endsWith('/')) {
        request.uri += 'index.html';
    } 
    // Check whether the URI is missing a file extension.
    else if (!uri.includes('.')) {
        request.uri += '/index.html';
    }

    return request;
}
EOF
}

locals {
  lambda_rst_stop_sart = var.db_stop_enable ? [
    {
      name        = "StartRds"
      source_path = "../lambda/start_rds"
      description = "Lambda function to start Rds."
    },
    {
      name        = "StopRds"
      source_path = "../lambda/stop_rds"
      description = "Lambda function to stop Rds."
    },
  ] : []
}

## Lambda function that stop and start rds:
module "lambda_function" {
  for_each = { for l in local.lambda_rst_stop_sart : l.name => l }

  source  = "terraform-aws-modules/lambda/aws"
  version = "4.7.1"

  function_name = each.key
  description   = each.value.description
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  publish       = true

  source_path = each.value.source_path


  environment_variables = {
    KEY    = "AutoShutDown"
    REGION = var.aws_region
    VALUE  = true
  }

  tags = {
    Name = "StopRds"
  }

  attach_policy = true
  policy        = aws_iam_policy.rdsstopstart.arn

  allowed_triggers = {
    ScanAmiRule = {
      principal  = "events.amazonaws.com"
      source_arn = module.eventbridge[0].eventbridge_rule_arns[each.key]
    }
  }
}


module "eventbridge" {
  count   = var.db_stop_enable ? 1 : 0
  source  = "terraform-aws-modules/eventbridge/aws"
  version = "1.17.1"

  create_bus = false

  rules = {
    StopRds = {
      description         = "Trigger lambda stop RDS"
      schedule_expression = var.db_stop_schedule_expression
    }

    StartRds = {
      description         = "Trigger lambda start RDS"
      schedule_expression = var.db_start_schedule_expression
    }
  }

  targets = {
    StartRds = [
      {
        name  = local.lambda_rst_stop_sart[0].name
        arn   = module.lambda_function[local.lambda_rst_stop_sart[1].name].lambda_function_arn
        input = jsonencode({ "job" : "cron-by-rate" })
      }
    ]

    StopRds = [
      {
        name  = local.lambda_rst_stop_sart[1].name
        arn   = module.lambda_function[local.lambda_rst_stop_sart[0].name].lambda_function_arn
        input = jsonencode({ "job" : "cron-by-rate" })
      }
    ]
  }
}