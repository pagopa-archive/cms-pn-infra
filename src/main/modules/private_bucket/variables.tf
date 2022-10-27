variable "bucket_prefix" {
  type        = string
  description = "Lambda function prefix. A random 4 digit number will be added at the end."
}

variable "enable_versioning" {
  type        = bool
  description = "Enable bucket versioning."
  default     = false
}

variable "cloudfront_origin_access_identity_arn" {
  type        = string
  description = "Cloudfront origin access identity arn."
  default     = null
}