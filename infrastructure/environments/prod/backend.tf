terraform {
  backend "s3" {
    bucket         = "prod-cloud-resume-terraform-state-bucket"
    key            = "prod/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
    profile        = "prod"
  }
}