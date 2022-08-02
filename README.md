# Terraform S3 Website & MX Records Modules

## Usage Guide
### 1. Update `terraform.tfvars` with domain
```HCL
domain = "example.com"
```
### 2. Update `backend.tf`
Change key to `<repo-name>/terraform.tfstate`, eg:
```HCL
  key = "terraform-aws-s3website/terraform.tfstate"
```
### 3. Push to github main branch to trigger terraform apply
See `.github/workflows/terraform.yml`

### 4. Plug in Nameservers to domain registrar
Go to namecheap.com or similar and plug these in to your domain.
```
$ terraform output
```
### 5. Update `terraform.tfvars` to enable S3 website provisioning
```HCL
enable_website = true
```
### 6. Push to github main branch to trigger terraform apply

-------------------------------------------
## Local Dev Setup
### 1. Install Dependencies
Install and init [pre-commit](https://pre-commit.com/) and [tflint](https://github.com/terraform-linters/tflint).
```
$ pip install pre-commit
$ brew install tflint
```
### 2. Initialise pre-commit hooks and tflint
```
$ tflint --init
$ pre-commit install
```
### 3. [Add checksums for all platforms to all terraform lock files](https://www.terraform.io/language/files/dependency-lock#new-provider-package-checksums)
```
$ make tf-lockfile
```
### 4. Run lint on all files
```
$ pre-commit run --all-files
```

-------------------------------------------

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
