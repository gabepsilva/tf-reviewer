output "bucket_name" {
  description = "Name of the public S3 bucket"
  value       = aws_s3_bucket.this.bucket
}

output "bucket_arn" {
  description = "ARN of the public S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_id" {
  description = "ID of the public S3 bucket"
  value       = aws_s3_bucket.this.id
}

output "website_endpoint" {
  description = "Website endpoint for the public S3 bucket"
  value       = aws_s3_bucket_website_configuration.this.website_endpoint
}
