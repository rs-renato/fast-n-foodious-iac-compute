# provider aws
provider "aws" {
  region = "us-east-1"
  profile = "tf-user"
}

# configuracao terraform
terraform {
  required_version = ">=1.0"
  
  # backend terraform para armazenar o estado no S3
  backend "s3" {
    bucket  = "fnf-terraform"
    key     = "fnf-terraform.tfstate"
    region  = "us-east-1"
    profile = "tf-user"
  }

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.69.0"
    }
  }
}