variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment name"
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

variable "cloudflare_api_token_ssm_path" {
  description = "SSM Parameter Store path for Cloudflare API token"
  type        = string
  default     = "/terraform/cloudflare/api_token"
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
  default     = ""
}

variable "dns_record_name" {
  description = "DNS record name (e.g., 'test' for test.example.com, '@' for root domain)"
  type        = string
  default     = ""
}

variable "cloudflare_proxied" {
  description = "Whether to proxy through Cloudflare (usually false for CloudFront)"
  type        = bool
  default     = false
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "github_repo_name" {
  description = "Name of repo on github for Cloud Resume Challenge"
  type        = string
}