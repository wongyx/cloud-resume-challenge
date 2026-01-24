terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  profile = var.environment
}

module "frontend" {
  source = "../../modules/frontend"
  
  bucket_name = var.bucket_name
  environment = var.environment
}