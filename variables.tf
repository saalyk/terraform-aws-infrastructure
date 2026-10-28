variable "aws_region" {
  description = "AWS region for the infrastructure"
  type        = string
  default     = "ap-southeast-2"
}

variable "bucket_name" {
  description = "Globally unique name for the S3 bucket"
  type        = string
}
