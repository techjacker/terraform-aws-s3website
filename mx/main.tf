resource "aws_route53_record" "mx_txt" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "TXT"
  ttl     = "300"
  records = [var.mx_txt, var.mx_spf]
}

resource "aws_route53_record" "mx_dkim_arc" {
  count   = 3
  zone_id = var.zone_id
  name    = "key${count.index + 1}._domainkey"
  type    = "CNAME"
  ttl     = "300"
  records = [
    "key${count.index + 1}.commonplacepurpose.com._domainkey.migadu.com."
  ]
}



resource "aws_route53_record" "mx" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "MX"
  ttl     = "300"
  records = var.mx
}

resource "aws_route53_record" "mx_dmarc" {
  zone_id = var.zone_id
  name    = "_dmarc.${var.domain}"
  type    = "TXT"
  ttl     = "300"
  records = [var.mx_dmarc]
}
