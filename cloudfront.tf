resource "aws_cloudfront_distribution" "website" {
    origin {
        custom_origin_config {
            http_port = 80,
            https_port = 443,
            origin_protocol_policy = "http-only",
            origin_ssl_protocols = ["TLSv1"]
        }
        # http://example.com.s3-website-eu-west-1.amazonaws.com/
        # https://s3-eu-west-1.amazonaws.com/example.com/index.html
        domain_name = "${var.domain}.s3-website-${data.aws_region.current.name}.amazonaws.com"
        origin_id   = "${var.domain}"
    }

    enabled = true
    price_class = "PriceClass_200"
    default_root_object = "index.html"
    # aliases = ["${var.domain}", "www.${var.domain}"]
    aliases = ["${var.domain}"]
    retain_on_delete = true
    http_version = "http2"

    custom_error_response {
       error_code         = 404
       response_code      = 200
       response_page_path = "/404.html"
    }

    default_cache_behavior {
        allowed_methods  = ["HEAD", "GET", "OPTIONS"]
        cached_methods  = ["HEAD", "GET", "OPTIONS"]
        target_origin_id = "${aws_s3_bucket.website.id}"

        forwarded_values {
          query_string = false

          cookies {
            forward = "none"
          }
        }

        viewer_protocol_policy = "redirect-to-https"
        min_ttl                = 0
        default_ttl            = 3600
        max_ttl                = 86400
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }
    viewer_certificate {
        acm_certificate_arn = "${var.acm-certificate-arn}"
        ssl_support_method = "sni-only"
        minimum_protocol_version = "TLSv1"
    }
}

