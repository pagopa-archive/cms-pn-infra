data "aws_secretsmanager_secret" "google_oauth" {
  name = local.secret_google_oauth
}


data "aws_secretsmanager_secret" "strapi" {
  name = local.secret_strapi
}
