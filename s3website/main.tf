provider "aws" {
  alias   = "us-east-1"
  region  = "us-east-1"
  # version = "~> 2.0"
}

locals {
  www_domain = "www.${var.domain}"

  domains = [
    var.domain,
    local.www_domain,
  ]

  website_endpoints = [
    aws_s3_bucket.main.website_endpoint,
    aws_s3_bucket.redirect.website_endpoint,
  ]
}

####################
# s3
# http://example.com.s3-website-eu-west-1.amazonaws.com/
####################
resource "aws_s3_bucket" "main" {
  bucket = var.domain
  policy = data.aws_iam_policy_document.s3_website_policy_www.json

  website {
    index_document = "index.html"
    error_document = "404"
  }
}

data "aws_iam_policy_document" "s3_website_policy_www" {
  statement {
    actions   = ["s3:GetObject"]
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.domain}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket" "redirect" {
  bucket = local.www_domain

  website {
    redirect_all_requests_to = aws_s3_bucket.main.id
  }
}

####################
# route 53
####################
resource "aws_route53_record" "A" {
  count   = length(local.domains)
  zone_id = var.zone_id
  name    = element(local.domains, count.index)
  type    = "A"

  alias {
    name                   = element(aws_cloudfront_distribution.website.*.domain_name, count.index)
    zone_id                = element(aws_cloudfront_distribution.website.*.hosted_zone_id, count.index)
    evaluate_target_health = false
  }
}

# https://www.terraform.io/docs/providers/aws/r/acm_certificate.html
resource "aws_acm_certificate" "cert" {
  provider                  = aws.us-east-1
  domain_name               = "*.${var.domain}"
  subject_alternative_names = [var.domain]
  validation_method         = "DNS"

  tags = {
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# https://www.terraform.io/docs/providers/aws/r/acm_certificate_validation.html
resource "aws_route53_record" "cert_validation" {
  depends_on = [aws_acm_certificate.cert]
  name       = aws_acm_certificate.cert.domain_validation_options.0.resource_record_name
  type       = aws_acm_certificate.cert.domain_validation_options.0.resource_record_type
  zone_id    = var.zone_id
  records    = [aws_acm_certificate.cert.domain_validation_options.0.resource_record_value]
  ttl        = 60
}

resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.us-east-1
  depends_on              = [aws_acm_certificate.cert, aws_route53_record.cert_validation]
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}


####################
# cloudfront
####################
resource "aws_cloudfront_distribution" "website" {
  depends_on          = [aws_acm_certificate_validation.cert]
  count               = length(local.domains)
  enabled             = true
  aliases             = [element(local.domains, count.index)]
  default_root_object = element(local.domains, count.index) == var.domain ? "index.html" : ""

  price_class      = "PriceClass_200"
  retain_on_delete = true
  http_version     = "http2"

  origin {
    # http://example.com.s3-website-eu-west-1.amazonaws.com/
    # https://s3-eu-west-1.amazonaws.com/example.com/index.html
    domain_name = element(local.website_endpoints, count.index)

    origin_id = "S3-${element(local.domains, count.index)}"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_ssl_protocols     = ["TLSv1"]
    }
  }

  custom_error_response {
    error_code         = 404
    response_code      = 404
    response_page_path = "/404.html"
  }

  default_cache_behavior {
    allowed_methods  = ["HEAD", "GET", "OPTIONS"]
    cached_methods   = ["HEAD", "GET", "OPTIONS"]
    target_origin_id = "S3-${element(local.domains, count.index)}"
    compress         = var.enable_gzip

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = var.cdn_min_ttl
    default_ttl            = var.cdn_default_ttl
    max_ttl                = var.cdn_max_ttl
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
}

resource "aws_route53_health_check" "health_check" {
  depends_on        = [aws_route53_record.A]
  count             = var.enable_health_check ? 1 : 0
  fqdn              = var.domain
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = var.domain
  }
}

resource "aws_cloudwatch_metric_alarm" "health_check_alarm" {
  provider            = aws.us-east-1
  count               = var.enable_health_check ? 1 : 0
  alarm_name          = "${var.domain}-health-check"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "1.0"
  alarm_description   = "This metric monitors the health of the endpoint"
  ok_actions          = var.health_check_alarm_sns_topics
  alarm_actions       = var.health_check_alarm_sns_topics
  treat_missing_data  = "breaching"

  dimensions = {
    HealthCheckId = aws_route53_health_check.health_check[0].id
  }
}
