terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# DNS records for CloudFront
resource "cloudflare_record" "resume" {
  zone_id = var.cloudflare_zone_id
  name    = var.record_name
  content   = var.cloudfront_domain_name
  type    = "CNAME"
  proxied = var.cloudflare_proxied
  ttl     = var.cloudflare_proxied ? 1 : 3600  # Auto TTL when proxied, otherwise 1 hour

  comment = "Resume website - ${var.environment}"
}

