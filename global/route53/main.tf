resource "aws_route53_zone" "primary" {
  name = "pageturner.io"
}

resource "aws_route53_record" "pageturner_io_certificate_validation" {
  name    = "${lookup(var.pageturner_io_certificate_validation_option, "resource_record_name")}"
  type    = "${lookup(var.pageturner_io_certificate_validation_option, "resource_record_type")}"
  zone_id = "${aws_route53_zone.primary.id}"
  records = ["${lookup(var.pageturner_io_certificate_validation_option, "resource_record_value")}"]
  ttl     = 60
}

resource "aws_route53_record" "website" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = ""
  type    = "A"

  alias {
    name                   = "${var.cloudfront_distribution_website_domain}"
    zone_id                = "${var.cloudfront_distribution_website_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "website_www" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "www"
  type    = "CNAME"
  ttl     = "300"
  records = ["${var.cloudfront_distribution_website_domain}"]
}
