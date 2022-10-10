output "backend_bucket_name" {
  value = aws_s3_bucket.terraform_states.bucket
}

output "dynamodb_lock_table" {
  value = aws_dynamodb_table.dynamodb-terraform-state-lock.name
}

output "github_iac_role_arn" {
  value = aws_iam_role.githubiac.arn
}