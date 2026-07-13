resource "aws_s3_bucket" "public_demo" {
  bucket = var.public_demo_bucket_name

  # AWS uses tags (equivalent of "labels" elsewhere).
  tags = {
    Project = "tf-reviewer"
    Purpose = "public-demo"
    Name    = "tf-reviewer-public-demo"
    Version = "1.0"
  }
}

# Allow public ACLs/policies so the bucket can be world-readable and listable.
resource "aws_s3_bucket_public_access_block" "public_demo" {
  bucket = aws_s3_bucket.public_demo.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "public_demo" {
  bucket = aws_s3_bucket.public_demo.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "public_demo" {
  depends_on = [
    aws_s3_bucket_ownership_controls.public_demo,
    aws_s3_bucket_public_access_block.public_demo,
  ]

  bucket = aws_s3_bucket.public_demo.id
  acl    = "public-read"
}

# Public list + get so contents are browsable / crawlable.
resource "aws_s3_bucket_policy" "public_demo" {
  depends_on = [aws_s3_bucket_public_access_block.public_demo]

  bucket = aws_s3_bucket.public_demo.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = ["${aws_s3_bucket.public_demo.arn}/*"]
      },
      {
        Sid       = "PublicListBucket"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:ListBucket"]
        Resource  = [aws_s3_bucket.public_demo.arn]
      }
    ]
  })
}

# Website hosting makes the bucket indexable via HTTP (index document).
resource "aws_s3_bucket_website_configuration" "public_demo" {
  bucket = aws_s3_bucket.public_demo.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "public_demo" {
  bucket = aws_s3_bucket.public_demo.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
