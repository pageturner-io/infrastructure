output "pageturner_io_certificate_arn" {
  value = "${aws_acm_certificate.pageturner_io.arn}"
}

output "pageturner_io_certificate_validation_option" {
  value = "${aws_acm_certificate.pageturner_io.domain_validation_options[0]}"
}
