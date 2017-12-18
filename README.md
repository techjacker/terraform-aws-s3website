# Terraform Modules


## Example Usage

### 1. Update `.env` file values

```Shell
DOMAIN="example.com"
```

### 2. Create TLS certificate

```Shell
./aws-tls-certificate.sh
```

### 3. Update `variables.tf` with acm-certificate-arn
```HCL
# created manually with aws-tls-certificate.sh script
variable "acm-certificate-arn" {
  # default = ""
}
```

### 4. Update terraform `main.tf` to include modules from this repo

```HCL
module "dnszone" {
  source    = "git@github.com:techjacker/terraform//dnszone"
  domain    = "${var.domain}"
}

module "s3website" {
  source    			 = "git@github.com:techjacker/terraform//s3website"
  domain    			 = "${var.domain}"
  # created manually with aws-tls-certificate.sh script
  acm-certificate-arn    = "${var.acm-certificate-arn}"
  zone_id   			 = "${module.dnszone.zone_id}"
}

module "mx" {
  source    = "git@github.com:techjacker/terraform//mx"
  zone_id   = "${module.dnszone.zone_id}"
  domain    = "${var.domain}"
  mx        = "${var.mx}"
  mx_spf    = "${var.mx_spf}"
  mx_dkim   = "${var.mx_dkim}"
  mx_dmarc  = "${var.mx_dmarc}"
}
```

### 4. Run terraform
```Shell
terraform env new prod
terraform env select prod
terraform get
terraform plan
terraform apply
```

### 5. Test
```Shell
$ curl -sI http://example.com | grep -E '(301|Server|Location|X-Cache|HTTP)'
  HTTP/1.1 301 Moved Permanently
  Server: CloudFront
  Location: https://example.com/
  X-Cache: Redirect from cloudfront

$ curl -sI https://example.com | grep -E '(X-Cache|HTTP)'
  HTTP/1.1 200 OK
  X-Cache: Hit from cloudfront

$ curl -sI http://www.example.com | grep -E '(301|Server|Location|X-Cache|HTTP)'
  HTTP/1.1 301 Moved Permanently
  Server: CloudFront
  Location: https://www.example.com/
  X-Cache: Redirect from cloudfront

$ curl -sI https://www.example.com | grep -E '(301|Server|Location|HTTP)'
  HTTP/1.1 301 Moved Permanently
  Location: https://example.com/
  Server: AmazonS3
```
