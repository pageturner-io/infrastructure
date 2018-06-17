output "aws_s3_bucket_builds_bucket" {
  value = "${aws_s3_bucket.builds.bucket}"
}

output "aws_s3_bucket_builds_arn" {
  value = "${aws_s3_bucket.builds.arn}"
}

output "aws_s3_bucket_website_bucket" {
  value = "${aws_s3_bucket.website.bucket}"
}

output "website_endpoint" {
  value = "${aws_s3_bucket.website.website_endpoint}"
}

output "aws_s3_bucket_website_arn" {
  value = "${aws_s3_bucket.website.arn}"
}
