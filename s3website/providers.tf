# TODO: check if cert manager still needs us-east-1 region
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
  # version = "~> 2.0"
}
