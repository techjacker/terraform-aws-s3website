provider "aws" {
  # required_version = ">= 1.2.0"

  region = var.region
  default_tags {
    tags = var.tags
  }
}
