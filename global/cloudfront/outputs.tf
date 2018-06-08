output "cloudfront_distribution_website_domain" {
  value = "${aws_cloudfront_distribution.website.domain_name}"
}
