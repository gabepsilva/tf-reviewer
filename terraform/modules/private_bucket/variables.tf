variable "bucket_name" {
  type        = string
  description = "Name of the private S3 bucket"
}

variable "project" {
  type        = string
  description = "Project tag value applied to the bucket"
}

variable "billing_code" {
  type        = string
  description = "Billing code tag value applied to the bucket"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags applied to the bucket"
  default     = {}
}
