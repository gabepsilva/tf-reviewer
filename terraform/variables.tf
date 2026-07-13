variable "aws_region" {
  type        = string
  description = "AWS region for tf-reviewer resources"
  default     = "us-east-1"
}

variable "public_bucket_name" {
  type        = string
  description = "Name of the tf-reviewer public S3 bucket"
}
