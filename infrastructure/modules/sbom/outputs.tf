output "sbom_bucket_name" {
  description = "Name of the SBOM S3 bucket"
  value       = aws_s3_bucket.sbom_storage.id
}

output "sbom_bucket_arn" {
  description = "ARN of the SBOM S3 bucket"
  value       = aws_s3_bucket.sbom_storage.arn
}
