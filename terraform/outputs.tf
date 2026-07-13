output "demo_bucket_name" {
  description = "Name of the demo S3 bucket"
  value       = aws_s3_bucket.demo.bucket
}

output "demo_bucket_arn" {
  description = "ARN of the demo S3 bucket"
  value       = aws_s3_bucket.demo.arn
}

output "demo_website_endpoint" {
  description = "Website endpoint for the public demo S3 bucket"
  value       = aws_s3_bucket_website_configuration.demo.website_endpoint
}
