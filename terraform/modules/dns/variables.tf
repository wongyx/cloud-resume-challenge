variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
}

variable "record_name" {
  description = "DNS record name (e.g., 'test' for test.example.com, 'www' for www.example.com, '@' for root)"
  type        = string
}

variable "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  type        = string
}

variable "environment" {
  description = "Environment (test or prod)"
  type        = string
}

variable "cloudflare_proxied" {
  description = "Whether to proxy through Cloudflare (orange cloud)"
  type        = bool
  default     = false  # False for CloudFront setups to avoid double CDN
}