module "public_bucket" {
  source = "./modules/public_bucket"

  bucket_name  = var.public_bucket_name
  project      = var.project
  billing_code = var.billing_code

  tags = {
    Purpose = "public"
    Name    = "tf-reviewer-public"
    Version = "1.0"
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
