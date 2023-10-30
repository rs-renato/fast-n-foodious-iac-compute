# provider aws
provider "aws" {
  region = "us-east-1"
}

# configuracao terraform
terraform {
  required_version = ">=1.0"

  backend "s3" {
    bucket  = "fnf-terraform-compute"
    key     = "terraform.tfstate"
    region  = "us-east-1"
  }

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.21.0"
    }
  }
}