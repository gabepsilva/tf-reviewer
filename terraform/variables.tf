variable "aws_region" {
  type        = string
  description = "AWS region for demo resources"
  default     = "us-east-1"
}

variable "demo_bucket_name" {
  type        = string
  description = "Name of the demo S3 bucket to create"
}
