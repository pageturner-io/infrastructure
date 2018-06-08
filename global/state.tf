terraform {
  backend "s3" {
    bucket  = "pageturner-terraform-state"
    key     = "global/terraform.tfstate"
    region  = "eu-west-1"
    profile = ""
    encrypt = true
  }
}
