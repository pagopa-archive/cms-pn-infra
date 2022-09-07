## IAM user who can manage the infrastructure definition
data "aws_iam_policy" "admin_access" {
  name = "AdministratorAccess"
}

# Usar able to manga the infrastructure.
resource "aws_iam_user" "strapi" {
  name = "Strapi"
}

resource "aws_iam_access_key" "strapi" {
  user = aws_iam_user.strapi.name
}


resource "aws_iam_policy" "upload_image" {
  name        = "S3UploadImages"
  path        = "/"
  description = "Policy to allow to manage files in S3 bucket"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:GetObjectAttributes",
          "s3:ListBucket",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = aws_s3_bucket.images.arn
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "strapi-policy" {
  name       = "strapi-policy"
  users      = [aws_iam_user.strapi.name]
  policy_arn = aws_iam_policy.upload_image.arn
}