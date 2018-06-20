terraform {
  backend "s3" {
    bucket  = "pageturner-terraform-state"
    key     = "production/terraform.tfstate"
    region  = "eu-west-1"
    profile = ""
    encrypt = true
  }
}
