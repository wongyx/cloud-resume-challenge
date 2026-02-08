terraform {
  backend "s3" {
    bucket         = "test-cloud-resume-terraform-state-bucket"
    key            = "test/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
    profile        = "test"
  }
}