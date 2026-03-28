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
