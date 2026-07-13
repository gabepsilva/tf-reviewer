output "public_bucket_name" {
  description = "Name of the tf-reviewer public S3 bucket"
  value       = module.public_bucket.bucket_name
}

output "public_bucket_arn" {
  description = "ARN of the tf-reviewer public S3 bucket"
  value       = module.public_bucket.bucket_arn
}

output "public_bucket_website_endpoint" {
  description = "Website endpoint for the tf-reviewer public S3 bucket"
  value       = module.public_bucket.website_endpoint
}
