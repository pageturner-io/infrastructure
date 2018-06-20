provider "aws" {
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
  region     = "${var.aws_region}"
}

module "cognito" {
  source = "./cognito"

  google_oauth_client_id     = "${var.google_oauth_client_id}"
  google_oauth_client_secret = "${var.google_oauth_client_secret}"

  facebook_app_id     = "${var.facebook_app_id}"
  facebook_app_secret = "${var.facebook_app_secret}"
}
