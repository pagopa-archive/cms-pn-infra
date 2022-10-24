resource "random_integer" "bucket_suffix" {
  min = 1
  max = 9999
}
resource "aws_s3_bucket" "cms_media" {
  bucket = format("cms-images-%04s", random_integer.bucket_suffix.result)

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    name = "Content images"
  }
}

/*
resource "aws_s3_bucket_acl" "terraform_states" {
  bucket = aws_s3_bucket.terraform_states.id
  acl    = "private"
}
*/

resource "aws_s3_bucket_public_access_block" "cms_media" {
  bucket                  = aws_s3_bucket.cms_media.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "cms_media" {
  bucket = aws_s3_bucket.cms_media.id
  versioning_configuration {
    status = "Enabled"
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.images.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.main.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudfront" {
  bucket = aws_s3_bucket.images.id
  policy = data.aws_iam_policy_document.s3_policy.json
}
