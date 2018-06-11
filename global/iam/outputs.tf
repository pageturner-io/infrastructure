output "Pageturner User Access Key" {
  value = "Access Key ID: ${aws_iam_access_key.pageturner.id} \n Secret Access Key: ${aws_iam_access_key.pageturner.secret}"
}

output "aws_iam_role_codepipeline_arn" {
  value = "${aws_iam_role.codepipeline.arn}"
}

output "aws_iam_role_codebuild_arn" {
  value = "${aws_iam_role.codebuild.arn}"
}
