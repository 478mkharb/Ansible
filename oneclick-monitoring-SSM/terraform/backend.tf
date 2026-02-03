terraform {
  backend "s3" {
    bucket         = "oneclick-terraform-state-036253061030"
    key            = "oneclick-monitoring/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
