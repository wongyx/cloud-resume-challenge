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

# Apex domain A record (only in production, for redirection to www)
resource "cloudflare_record" "apex" {
  count   = var.environment == "prod" ? 1 : 0
  
  zone_id = var.cloudflare_zone_id
  name    = "@"  
  content = "192.0.2.1"  # Dummy IP
  type    = "A"
  proxied = true  
  ttl     = 1
  comment = "Apex domain for redirect - ${var.environment}"
}

# Redirect Rule: apex to www (only in production)
resource "cloudflare_ruleset" "apex_redirect" {
  count   = var.environment == "prod" ? 1 : 0
  
  zone_id     = var.cloudflare_zone_id
  name        = "Redirect apex to www"
  description = "Redirect example.com to www.example.com"
  kind        = "zone"
  phase       = "http_request_dynamic_redirect"

  rules {
    action      = "redirect"
    description = "301 redirect from apex to www subdomain"
    enabled     = true
    
    expression = "http.request.full_uri wildcard \"*://${replace(var.record_name, "www.", "")}/*\""
    
    action_parameters {
      from_value {
        status_code = 301
        target_url {
          expression = "concat(\"https://www.\", http.host, http.request.uri.path)"
        }
        preserve_query_string = true
      }
    }
  }
}