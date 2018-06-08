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
