resource "aws_route53_record" "mx" {
  zone_id = "${var.zone_id}"
  name = "${var.domain}"
  type = "MX"
  ttl = "300"
  records = ["${var.mx}"]
}

resource "aws_route53_record" "mx_spf" {
  zone_id = "${var.zone_id}"
  name = "${var.domain}"
  type = "TXT"
  ttl = "300"
  records = ["${var.mx_spf}"]
}

resource "aws_route53_record" "mx_dkim" {
  zone_id = "${var.zone_id}"
  name = "default._domainkey.${var.domain}"
  type = "TXT"
  ttl = "300"
  records = ["${var.mx_dkim}"]
}

resource "aws_route53_record" "mx_dmarc" {
  zone_id = "${var.zone_id}"
  name = "_dmarc.${var.domain}"
  type = "TXT"
  ttl = "300"
  records = ["${var.mx_dmarc}"]
}
