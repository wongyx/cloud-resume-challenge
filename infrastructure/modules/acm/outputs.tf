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