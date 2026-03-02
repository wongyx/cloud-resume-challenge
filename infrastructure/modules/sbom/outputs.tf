output "sbom_bucket_name" {
  description = "Name of the SBOM S3 bucket"
  value       = try(aws_s3_bucket.sbom_storage[0].id, null)
}

output "sbom_bucket_arn" {
  description = "ARN of the SBOM S3 bucket"
  value       = try(aws_s3_bucket.sbom_storage[0].id, null)
}
