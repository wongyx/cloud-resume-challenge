resource "aws_s3_bucket" "resume" {
  bucket = var.bucket_name
  force_destroy = var.environment == "test" ? true : false

  tags = {
    Name        = "Resume Website"
    Environment = var.environment
  }
}

locals {
  index_html_content = templatefile("${path.module}/../../../frontend/index.html.tpl", {
    api_endpoint = var.api_endpoint
  })
}

locals {
  mime_types = {
    ".html" = "text/html"
    ".css"  = "text/css"
    ".js"   = "application/javascript"
    ".json" = "application/json"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".gif"  = "image/gif"
    ".svg"  = "image/svg+xml"
    ".ico"  = "image/x-icon"
  }
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.resume.id
  key          = "index.html"
  content      = local.index_html_content
  content_type = "text/html"
  etag         = md5(local.index_html_content)
}

resource "aws_s3_object" "style" {
  bucket       = aws_s3_bucket.resume.id
  key          = "style.css"
  source       = "${path.module}/../../../frontend/style.css"
  content_type = "text/css"
  etag         = filemd5("${path.module}/../../../frontend/style.css")
}

resource "aws_s3_bucket_versioning" "resume" {
  bucket = aws_s3_bucket.resume.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "example" {
  bucket = aws_s3_bucket.resume.id

  rule {
    id     = "delete-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 3
    }
  }
}

resource "aws_s3_bucket_website_configuration" "resume" {
  bucket = aws_s3_bucket.resume.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "resume" {
  bucket = aws_s3_bucket.resume.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "resume" {
  bucket = aws_s3_bucket.resume.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.resume.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.resume.arn
          }
        }
      }
    ]
  })

  depends_on = [
    aws_s3_bucket_public_access_block.resume,
    aws_cloudfront_distribution.resume
  ]
}