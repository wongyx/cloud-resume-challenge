terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

resource "aws_acm_certificate" "resume" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Name        = "Resume Website Certificate"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Output validation records for Cloudflare DNS
output "validation_records" {
  description = "DNS validation records to create"
  value = {
    for dvo in aws_acm_certificate.resume.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      value  = dvo.resource_record_value
    }
  }
}