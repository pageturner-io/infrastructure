provider "aws" {
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
  region     = "${var.aws_region}"
}

provider "aws" {
  region = "${var.aws_cloudfront_region}"
  alias  = "cloudfront"
}

provider "github" {
  token        = "${var.github_token}"
  organization = "${var.github_organization}"
}

module "github" {
  source = "./github"
}

module "iam" {
  source = "./iam"
}

module "s3" {
  source = "./s3"
}

module "acm" {
  source = "./acm"

  pageturner_io_certificate_validation_fqdn = "${module.route53.pageturner_io_certificate_validation_fqdn}"
}

module "cloudfront" {
  source = "./cloudfront"

  website_endpoint              = "${module.s3.website_endpoint}"
  pageturner_io_certificate_arn = "${module.acm.pageturner_io_certificate_arn}"
}

module "route53" {
  source = "./route53"

  cloudfront_distribution_website_domain      = "${module.cloudfront.cloudfront_distribution_website_domain}"
  pageturner_io_certificate_validation_option = "${module.acm.pageturner_io_certificate_validation_option}"
}
