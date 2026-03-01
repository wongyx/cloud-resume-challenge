variable "sbom_bucket_name" {
  description = "Name of the SBOM S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment (test or prod)"
  type        = string
}
