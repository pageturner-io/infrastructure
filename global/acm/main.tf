resource "aws_acm_certificate" "pageturner_io" {
  domain_name       = "*.${var.root_domain_name}"
  validation_method = "DNS"

  subject_alternative_names = ["${var.root_domain_name}"]

  provider = "aws.cloudfront"
}

resource "aws_acm_certificate_validation" "pageturner_io" {
  certificate_arn = "${aws_acm_certificate.pageturner_io.arn}"

  validation_record_fqdns = [
    "${var.pageturner_io_certificate_validation_fqdn}",
  ]

  lifecycle {
    create_before_destroy = true
  }

  provider = "aws.cloudfront"
}
