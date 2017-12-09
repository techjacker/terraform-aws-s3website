provider "aws" {}

data "aws_region" "current" {
  current = true
}

# created manually with aws-tls-certificate.sh script
variable "acm-certificate-arn" {
  # default = ""
}

# http://example.com.s3-website-eu-west-1.amazonaws.com/
variable "domain" {
  default = "example.com"
}

variable "zone_id" {
  description = "route53 hosted zone id"
}
