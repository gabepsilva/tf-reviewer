module "public_bucket" {
  source = "./modules/public_bucket"

  bucket_name = var.public_bucket_name

  tags = {
    Project = "tf-reviewer"
    Purpose = "public"
    Name    = "tf-reviewer-public"
    Version = "1.0"
  }
}
