module "public_bucket" {
  source = "./modules/public_bucket"

  bucket_name = var.public_demo_bucket_name

  tags = {
    Project = "tf-reviewer"
    Purpose = "public-demo"
    Name    = "tf-reviewer-public-demo"
    Version = "1.0"
  }
}
