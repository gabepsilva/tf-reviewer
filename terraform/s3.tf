module "public_bucket" {
  source = "./modules/public_bucket"

  bucket_name  = var.public_bucket_name
  project      = var.project
  billing_code = var.billing_code

  tags = {
    Purpose = "public"
    Name    = "tf-reviewer-public"
    Version = "1.2"
  }
}

module "private_bucket" {
  source = "./modules/private_bucket"

  bucket_name  = var.private_bucket_name
  project      = var.project
  billing_code = var.billing_code

  tags = {
    Purpose = "private"
    Name    = "tf-reviewer-private"
    Version = "1.0"
  }
}

# Intentionally hand-rolled (not the company module) — standards violation for demo review.
resource "aws_s3_bucket" "extra_private" {
  bucket = var.extra_private_bucket_name

  tags = {
    Project     = var.project
    BillingCode = var.billing_code
    Purpose     = "private"
    Name        = "tf-reviewer-extra-private"
    Version     = "1.0"
  }
}

resource "aws_s3_bucket_public_access_block" "extra_private" {
  bucket = aws_s3_bucket.extra_private.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
