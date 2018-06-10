output "cloudfront_distribution_website_domain" {
  value = "${aws_cloudfront_distribution.website.domain_name}"
}

output "cloudfront_distribution_website_zone_id" {
  value = "${aws_cloudfront_distribution.website.hosted_zone_id}"
}
