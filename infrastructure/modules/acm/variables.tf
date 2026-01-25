variable "domain_name" {
  description = "Domain name for the certificate"
  type        = string
}

variable "environment" {
  description = "Environment (test or prod)"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for DNS validation"
  type        = string
}