terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    # Filled by -backend-config / backend.hcl (not committed with secrets).
    # Bucket is created out-of-band; see README note in comments.
    key     = "public/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
