output "demo_bucket_name" {
  value = aws_s3_bucket.demo.bucket
}

output "demo_bucket_arn" {
  value = aws_s3_bucket.demo.arn
}

output "demo_website_endpoint" {
  value = aws_s3_bucket_website_configuration.demo.website_endpoint
}
