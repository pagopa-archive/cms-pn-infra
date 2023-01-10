resource "aws_amplify_app" "fe" {
  name                     = "Piattaforma Notifiche product website"
  repository               = local.fe_github_repository
  enable_branch_auto_build = true

  access_token = "${data.aws_secretsmanager_secret.github.arn}:GITHUB_TOKEN::"


  build_spec = <<-EOT
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - yarn install
        build:
          commands:
            - yarn build
      artifacts:
        baseDirectory: src/app
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT
  # The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|ttf|map|json)$)([^.]+$)/>"
    status = "200"
    target = "/index.html"
  }


  environment_variables = {
    STRAPI_TOKEN    = "todo"
    STRAPI_API_URL  = "https://cms.poc.pn.pagopa.it"
    "_CUSTOM_IMAGE" = "node:16",
  }
}