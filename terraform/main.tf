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

  # AWS uses tags (equivalent of "labels" elsewhere).
  tags = {
    Project = "tf-reviewer"
    Purpose = "demo"
    Version = "1.0"
  }
}

# Allow public ACLs/policies so the bucket can be world-readable and listable.
resource "aws_s3_bucket_public_access_block" "demo" {
  bucket = aws_s3_bucket.demo.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "demo" {
  bucket = aws_s3_bucket.demo.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "demo" {
  depends_on = [
    aws_s3_bucket_ownership_controls.demo,
    aws_s3_bucket_public_access_block.demo,
  ]

  bucket = aws_s3_bucket.demo.id
  acl    = "public-read"
}

# Public list + get so contents are browsable / crawlable.
resource "aws_s3_bucket_policy" "demo" {
  depends_on = [aws_s3_bucket_public_access_block.demo]

  bucket = aws_s3_bucket.demo.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = ["${aws_s3_bucket.demo.arn}/*"]
      },
      {
        Sid       = "PublicListBucket"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:ListBucket"]
        Resource  = [aws_s3_bucket.demo.arn]
      }
    ]
  })
}

# Website hosting makes the bucket indexable via HTTP (index document).
resource "aws_s3_bucket_website_configuration" "demo" {
  bucket = aws_s3_bucket.demo.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
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

output "demo_website_endpoint" {
  value = aws_s3_bucket_website_configuration.demo.website_endpoint
}
