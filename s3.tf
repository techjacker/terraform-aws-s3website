# http://example.com.s3-website-eu-west-1.amazonaws.com/
resource "aws_s3_bucket" "website" {
    bucket = "${var.domain}"
    acl = "public-read"
    policy = "${file("s3-website-policy.json")}"
    website {
        index_document = "index.html"
        error_document = "404.html"
    }
}

data "template_file" "routing_rules" {
  template = "${file("s3-website-www-routing.json")}"
  vars {
    target = "${var.domain}"
  }
}

resource "aws_s3_bucket" "website_www_redirect" {
    bucket = "www.${var.domain}"
    acl = "public-read"
    policy = "${file("s3-website-www-policy.json")}"
    website {
        # redirect_all_requests_to = "https://www.${var.domain}"
        index_document = "index.html"
        routing_rules = "${data.template_file.routing_rules.rendered}"
    }
}
