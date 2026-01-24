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

provider "aws" {
  region = var.aws_region
  profile = var.environment
}

provider "aws" {
  alias = "us_east_1"
  region = "us-east-1"
  profile = var.environment
}

data "aws_ssm_parameter" "cloudflare_api_token" {
  name = var.cloudflare_api_token_ssm_path
  with_decryption = true
}

provider "cloudflare" {
  api_token = data.aws_ssm_parameter.cloudflare_api_token.value
}

module "acm" {
  count  = var.domain_name != "" ? 1 : 0
  source = "../../modules/acm"
  
  providers = {
    aws        = aws.us_east_1  # ACM in us-east-1
    cloudflare = cloudflare
  }
  
  domain_name        = var.domain_name
  environment        = var.environment
  cloudflare_zone_id = var.cloudflare_zone_id
}

module "frontend" {
  source = "../../modules/frontend"
  
  bucket_name = var.bucket_name
  environment = var.environment
  domain_name = var.domain_name
  acm_certificate_arn = var.domain_name != "" ? module.acm[0].certificate_arn : ""

  depends_on = [module.acm]
}

module "dns" {
  count  = var.domain_name != "" ? 1 : 0
  source = "../../modules/dns"
  
  cloudflare_zone_id      = var.cloudflare_zone_id
  record_name             = var.dns_record_name
  cloudfront_domain_name  = module.frontend.cloudfront_domain_name
  environment             = var.environment
  cloudflare_proxied      = var.cloudflare_proxied
}

module "backend" {
  source = "../../modules/backend"

  environment          = var.environment
  aws_region          = var.aws_region
  dynamodb_table_name = "${var.environment}-${var.project_name}-visitor-counter"
  billing_mode        = "PAY_PER_REQUEST" 
  
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}