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
