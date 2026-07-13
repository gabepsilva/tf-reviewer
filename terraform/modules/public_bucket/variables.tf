variable "bucket_name" {
  type        = string
  description = "Name of the public S3 bucket"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the bucket"
  default     = {}
}

variable "index_document" {
  type        = string
  description = "S3 website index document key"
  default     = "index.html"
}

variable "error_document" {
  type        = string
  description = "S3 website error document key"
  default     = "error.html"
}
