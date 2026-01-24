# Automatically create DNS validation records in Cloudflare
resource "cloudflare_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.resume.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      value = dvo.resource_record_value
      type  = dvo.resource_record_type
    }
  }

  zone_id = var.cloudflare_zone_id
  name    = each.value.name
  content   = each.value.value
  type    = each.value.type
  ttl     = 60
  proxied = false

  comment = "ACM certificate validation for ${var.environment}"
}

# Wait for certificate validation to complete
resource "aws_acm_certificate_validation" "resume" {
  certificate_arn         = aws_acm_certificate.resume.arn
  validation_record_fqdns = [for record in cloudflare_record.cert_validation : record.hostname]

  timeouts {
    create = "45m"  # Give plenty of time for DNS propagation and validation
  }
}