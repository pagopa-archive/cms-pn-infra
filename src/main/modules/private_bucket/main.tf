resource "random_integer" "this" {
  min = 1
  max = 9999
}

locals {
  bucket_name = format(var.bucket_prefix, random_integer.this.result)
}

resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name

  tags = {
    name = local.bucket_name
  }
}

resource "aws_s3_bucket_versioning" "this" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "this" {
  count = var.cloudfront_origin_access_identity_arn != null ? 1 : 0
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [var.cloudfront_origin_access_identity_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.cloudfront_origin_access_identity_arn != null ? 1 : 0
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this[0].json
}