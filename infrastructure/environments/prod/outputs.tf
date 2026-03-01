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

output "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = module.frontend.cloudfront_domain_name
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

output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = module.backend.dynamodb_table_name
}

output "dynamodb_table_arn" {
  description = "DynamoDB table ARN"
  value       = module.backend.dynamodb_table_arn
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = module.backend.lambda_function_name
}

output "lambda_function_arn" {
  description = "Lambda function ARN"
  value       = module.backend.lambda_function_arn
}

output "api_gateway_url" {
  description = "API Gateway base URL"
  value       = module.backend.api_gateway_url
}

output "api_endpoint" {
  description = "Full API endpoint for visitor counter"
  value       = module.backend.api_endpoint
}

output "sbom_bucket_name" {
  description = "Name of the SBOM S3 bucket"
  value       = module.sbom.sbom_bucket_name
}