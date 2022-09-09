resource "random_integer" "bucket_suffix" {
  min = 1
  max = 9999
}
resource "aws_s3_bucket" "images" {
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

resource "aws_s3_bucket_public_access_block" "terraform_states" {
  bucket                  = aws_s3_bucket.images.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "terraform_states" {
  bucket = aws_s3_bucket.images.id
  versioning_configuration {
    status = "Enabled"
  }
}