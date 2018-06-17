resource "aws_codebuild_project" "website_test" {
  name          = "website-test"
  description   = "Tests the Pageturner Website"
  build_timeout = "5"
  service_role  = "${var.aws_iam_role_codebuild_arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = "${var.aws_s3_bucket_builds_bucket}/cache"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/nodejs:10.1.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "S3"
    location  = "${var.aws_s3_bucket_builds_bucket}/website"
    buildspec = "buildspec-test.yml"
  }

  tags {
    "Environment" = "Test"
  }
}

resource "aws_codebuild_project" "website_build" {
  name          = "website-build"
  description   = "Builds the Pageturner Website"
  build_timeout = "5"
  service_role  = "${var.aws_iam_role_codebuild_arn}"

  artifacts {
    type      = "S3"
    location  = "${var.aws_s3_bucket_website_bucket}"
    packaging = "ZIP"
    path      = "build"
  }

  cache {
    type     = "S3"
    location = "${var.aws_s3_bucket_builds_bucket}/cache"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/nodejs:10.1.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "S3"
    location  = "${var.aws_s3_bucket_builds_bucket}/website"
    buildspec = "buildspec-build.yml"
  }

  tags {
    "Environment" = "Build"
  }
}
