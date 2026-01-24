# CloudFront Origin Access Control (OAC)
resource "aws_cloudfront_origin_access_control" "resume" {
  name                              = "${var.bucket_name}-oac"
  description                       = "OAC for ${var.bucket_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "resume" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Resume website distribution - ${var.environment}"
  default_root_object = "index.html"
  aliases             = var.domain_name != "" ? [var.domain_name] : []
  price_class         = "PriceClass_All"  # Use only North America and Europe (cheapest)

  origin {
    domain_name              = aws_s3_bucket.resume.bucket_regional_domain_name
    origin_id                = "S3-${aws_s3_bucket.resume.id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.resume.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.resume.id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600    # 1 hour
    max_ttl                = 86400   # 24 hours
    compress               = true
  }

  # Custom error response for SPA behavior (optional)
  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 300
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 300
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
viewer_certificate {
  # Use CloudFront default certificate when no custom domain
  cloudfront_default_certificate = var.domain_name == "" ? true : false
    
  # Use ACM certificate when custom domain is specified
  acm_certificate_arn      = var.domain_name != "" ? var.acm_certificate_arn : null
  ssl_support_method       = var.domain_name != "" ? "sni-only" : null
  minimum_protocol_version = var.domain_name != "" ? "TLSv1.2_2021" : null
}

  tags = {
    Name        = "Resume CloudFront Distribution"
    Environment = var.environment
  }
}