output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate_validation.resume.certificate_arn
}

output "certificate_status" {
  description = "Status of the certificate"
  value       = aws_acm_certificate.resume.status
}

output "domain_validation_options" {
  description = "Domain validation options"
  value       = aws_acm_certificate.resume.domain_validation_options
}

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