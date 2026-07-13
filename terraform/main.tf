terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    # Filled by -backend-config / backend.hcl (not committed with secrets).
    # Bucket is created out-of-band; see README note in comments.
    key     = "demo/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type        = string
  description = "AWS region for demo resources"
  default     = "us-east-1"
}

variable "demo_bucket_name" {
  type        = string
  description = "Name of the demo S3 bucket to create"
}

resource "aws_s3_bucket" "demo" {
  bucket = var.demo_bucket_name

  tags = {
    Project = "tf-reviewer"
    Purpose = "demo"
  }
}

resource "aws_s3_bucket_public_access_block" "demo" {
  bucket = aws_s3_bucket.demo.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "demo" {
  bucket = aws_s3_bucket.demo.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

output "demo_bucket_name" {
  value = aws_s3_bucket.demo.bucket
}

output "demo_bucket_arn" {
  value = aws_s3_bucket.demo.arn
}
