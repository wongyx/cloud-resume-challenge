output "bucket_name" {
  value = module.frontend.bucket_name
}

output "website_endpoint" {
  value = module.frontend.bucket_website_endpoint
}

output "cloudfront_url" {
  description = "CloudFront distribution URL"
  value       = module.frontend.cloudfront_url
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = module.frontend.cloudfront_distribution_id
}

output "dns_record" {
  description = "DNS record hostname"
  value       = var.domain_name != "" ? module.dns[0].record_hostname : "No custom domain configured"
}

output "certificate_arn" {
  description = "ACM certificate ARN"
  value       = var.domain_name != "" ? module.acm[0].certificate_arn : "No certificate (using CloudFront default)"
}

output "website_url" {
  description = "Full website URL"
  value       = var.domain_name != "" ? "https://${var.domain_name}" : module.frontend.cloudfront_url
}
