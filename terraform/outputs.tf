output "public_demo_bucket_name" {
  description = "Name of the tf-reviewer public demo S3 bucket"
  value       = aws_s3_bucket.public_demo.bucket
}

output "public_demo_bucket_arn" {
  description = "ARN of the tf-reviewer public demo S3 bucket"
  value       = aws_s3_bucket.public_demo.arn
}

output "public_demo_website_endpoint" {
  description = "Website endpoint for the tf-reviewer public demo S3 bucket"
  value       = aws_s3_bucket_website_configuration.public_demo.website_endpoint
}
