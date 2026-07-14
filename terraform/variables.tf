variable "aws_region" {
  type        = string
  description = "AWS region for tf-reviewer resources"
  default     = "us-east-1"
}

variable "project" {
  type        = string
  description = "Project tag applied to all resources"
  default     = "tf-reviewer"
}

variable "billing_code" {
  type        = string
  description = "Billing code tag applied to all resources"
}

variable "public_bucket_name" {
  type        = string
  description = "Name of the tf-reviewer public S3 bucket"
}

variable "private_bucket_name" {
  type        = string
  description = "Name of the tf-reviewer private S3 bucket"
}

variable "extra_private_bucket_name" {
  type        = string
  description = "Name of an extra private S3 bucket (hand-rolled, not via module)"
}
