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

module "acm" {
  source = "./acm"

  pageturner_io_certificate_validation_fqdn = "${module.route53.pageturner_io_certificate_validation_fqdn}"
}

module "codebuild" {
  source = "./codebuild"

  aws_iam_role_codebuild_arn = "${module.iam.aws_iam_role_codebuild_arn}"

  aws_s3_bucket_builds_bucket  = "${module.s3.aws_s3_bucket_builds_bucket}"
  aws_s3_bucket_website_bucket = "${module.s3.aws_s3_bucket_website_bucket}"
}

module "codepipeline" {
  source = "./codepipeline"

  aws_iam_role_codepipeline_arn = "${module.iam.aws_iam_role_codepipeline_arn}"

  aws_s3_bucket_builds_bucket = "${module.s3.aws_s3_bucket_builds_bucket}"

  github_organization = "${var.github_organization}"
  github_token        = "${var.github_token}"
}

module "cloudfront" {
  source = "./cloudfront"

  website_endpoint              = "${module.s3.website_endpoint}"
  pageturner_io_certificate_arn = "${module.acm.pageturner_io_certificate_arn}"
}

module "iam" {
  source = "./iam"

  aws_s3_bucket_website_arn = "${module.s3.aws_s3_bucket_website_arn}"
  aws_s3_bucket_builds_arn  = "${module.s3.aws_s3_bucket_builds_arn}"
}

module "route53" {
  source = "./route53"

  cloudfront_distribution_website_domain  = "${module.cloudfront.cloudfront_distribution_website_domain}"
  cloudfront_distribution_website_zone_id = "${module.cloudfront.cloudfront_distribution_website_zone_id}"

  pageturner_io_certificate_validation_option = "${module.acm.pageturner_io_certificate_validation_option}"
}

module "s3" {
  source = "./s3"
}
