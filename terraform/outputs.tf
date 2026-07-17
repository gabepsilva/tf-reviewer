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

output "private_bucket_name" {
  description = "Name of the tf-reviewer private S3 bucket"
  value       = module.private_bucket.bucket_name
}

output "private_bucket_arn" {
  description = "ARN of the tf-reviewer private S3 bucket"
  value       = module.private_bucket.bucket_arn
}

output "extra_private_bucket_name" {
  description = "Name of the hand-rolled extra private S3 bucket"
  value       = aws_s3_bucket.extra_private.bucket
}

output "extra_private_bucket_arn" {
  description = "ARN of the hand-rolled extra private S3 bucket"
  value       = aws_s3_bucket.extra_private.arn
}
