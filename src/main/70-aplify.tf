data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["amplify.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "amplify" {
  name                = "DeployWithAmplify"
  assume_role_policy  = join("", data.aws_iam_policy_document.assume_role.*.json)
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess-Amplify"]
}

resource "aws_amplify_app" "fe" {
  name       = "pn-website-fe"
  repository = local.fe_github_repository
  #enable_branch_auto_build = true

  iam_service_role_arn = aws_iam_role.amplify.arn

  access_token = jsondecode(data.aws_secretsmanager_secret_version.github.secret_string)["GITHUB_TOKEN"]

  build_spec = <<-EOT
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - cd src/app
            - yarn install
        build:
          commands:
            - yarn build
      artifacts:
        baseDirectory: src/app/public
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT
  # The default rewrites and redirects added by the Amplify Console.
  /*
  custom_rule {
    source = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|ttf|map|json)$)([^.]+$)/>"
    status = "200"
    target = "/index.html"
  }
  */


  environment_variables = {
    STRAPI_TOKEN      = jsondecode(data.aws_secretsmanager_secret_version.strapi.secret_string)["STRAPI_TOKEN"]
    STRAPI_API_URL    = format("https://%s", aws_route53_record.cms.fqdn)
    "VERSION_NODE_16" = 16
  }
}

resource "aws_amplify_branch" "live" {
  app_id      = aws_amplify_app.fe.id
  branch_name = "main"
}

resource "aws_amplify_webhook" "live" {
  app_id      = aws_amplify_app.fe.id
  branch_name = aws_amplify_branch.live.branch_name
  description = "Live FE"
}

resource "aws_amplify_backend_environment" "example" {
  app_id           = aws_amplify_app.example.id
  environment_name = "example"

  deployment_artifacts = "app-example-deployment"
  stack_name           = "amplify-app-example"
}