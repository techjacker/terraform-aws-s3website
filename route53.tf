resource "aws_route53_zone" "website" {
  name = "${var.domain}"
}

resource "aws_route53_record" "root" {
  zone_id = "${aws_route53_zone.website.zone_id}"
  name = "${var.domain}"
  type = "A"
  alias {
    name = "${aws_cloudfront_distribution.website.domain_name}"
    zone_id = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.website.zone_id}"
  name = "www.${var.domain}"
  type = "CNAME"
  ttl = "300"
  records = ["www.${var.domain}.s3-website-${data.aws_region.current.name}.amazonaws.com"]
}
