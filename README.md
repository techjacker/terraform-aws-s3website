# Terraform S3 Website & MX Records Modules

## Domain TLS Certificate
TLS certificate generation and validation is done via DNS by Terraform (ie not by separate bash script).

## Example Usage
### Update terraform `variables.tf` file
#### Required variables
```HCL
variable "domain" {
  description = "The domain where to host the site. This must be the naked domain, e.g. `example.com`"
}
variable "route53_zone_id" {
  description = "route53 hosted zone id"
}
```
### Test
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
