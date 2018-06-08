output "Pageturner User Access Key" {
  value = "Access Key ID: ${aws_iam_access_key.pageturner.id} \n Secret Access Key: ${aws_iam_access_key.pageturner.secret}"
}
