variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment (test or prod)"
  type        = string
}

variable "domain_name" {
  description = "Name of domain hosting the website"
  type        = string
  default     = ""
}

variable "acm_certificate_arn" {
  description = "ARN of ACM certificate for CloudFront (only needed with custom domain)"
  type        = string
  default     = ""
}

variable "api_endpoint" {
  description = "API Gateway endpoint URL for visitor counter"
  type        = string
}