resource "random_integer" "bucket_cms_media" {
  min = 1
  max = 9999
}
resource "aws_s3_bucket" "cms_media" {
  bucket = format("cms-images-%04s", random_integer.bucket_cms_media.result)

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

data "aws_iam_policy_document" "s3_policy_media" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.cms_media.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.main.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudfront" {
  bucket = aws_s3_bucket.cms_media.id
  policy = data.aws_iam_policy_document.s3_policy_media.json
}


## Storage static website
resource "random_integer" "bucket_website_preview" {
  min = 1
  max = 9999
}
resource "aws_s3_bucket" "website_preview" {
  bucket = format("preview-%04s", random_integer.bucket_website_preview.result)

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    name = "Asset preview."
  }
}

resource "aws_s3_bucket_public_access_block" "website_preview" {
  bucket                  = aws_s3_bucket.website_preview.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "s3_policy_preview" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website_preview.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.main.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "website_preview" {
  bucket = aws_s3_bucket.website_preview.id
  policy = data.aws_iam_policy_document.s3_policy_preview.json
}