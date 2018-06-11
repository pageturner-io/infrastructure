resource "aws_iam_group" "admins" {
  name = "admins"
  path = "/admins/"
}

resource "aws_iam_group_policy" "admins_policy" {
  name  = "admins_policy"
  group = "${aws_iam_group.admins.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_user" "pageturner" {
  name = "pageturner"
}

resource "aws_iam_group_membership" "admins" {
  name = "admins-group-membership"

  users = [
    "${aws_iam_user.pageturner.name}",
  ]

  group = "${aws_iam_group.admins.name}"
}

resource "aws_iam_access_key" "pageturner" {
  user = "${aws_iam_user.pageturner.name}"
}

resource "aws_iam_role" "codebuild" {
  name = "codebuild"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role" "codepipeline" {
  name = "codepipeline"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild_website" {
  role = "${aws_iam_role.codebuild.name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${var.aws_s3_bucket_builds_arn}",
        "${var.aws_s3_bucket_builds_arn}/*",
        "${var.aws_s3_bucket_website_arn}",
        "${var.aws_s3_bucket_website_arn}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "codepipeline_website" {
  name = "codepipeline-website"
  role = "${aws_iam_role.codepipeline.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:DeleteObject",
        "s3:DeleteObjectVersion",
        "s3:PutObject",
        "s3:PutObjectVersion"
      ],
      "Resource": [
        "${var.aws_s3_bucket_builds_arn}",
        "${var.aws_s3_bucket_builds_arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
