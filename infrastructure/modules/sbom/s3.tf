resource "aws_s3_bucket" "sbom_storage" {
  bucket = var.sbom_bucket_name
  force_destroy = var.environment == "test" ? true : false
  
  tags = {
    Purpose     = "SBOM Storage"
    Project     = "Cloud Resume Challenge"
    Compliance  = "Security"
  }
}

resource "aws_s3_bucket_versioning" "sbom_storage" {
  bucket = aws_s3_bucket.sbom_storage.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sbom_storage" {
  bucket = aws_s3_bucket.sbom_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "sbom_storage" {
  bucket = aws_s3_bucket.sbom_storage.id

  rule {
    id     = "delete-old-versions"
    status = "Enabled"
    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 3
    }
  }
}

resource "aws_s3_bucket_public_access_block" "sbom_storage" {
  bucket = aws_s3_bucket.sbom_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}