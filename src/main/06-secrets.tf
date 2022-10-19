data "aws_secretsmanager_secret" "google_oauth" {
  name = local.secret_google_oauth
}


data "aws_secretsmanager_secret_version" "google_oauth" {
  secret_id = data.aws_secretsmanager_secret.google_oauth.id
}