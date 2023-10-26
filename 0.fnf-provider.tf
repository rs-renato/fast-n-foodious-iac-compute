# provider aws
provider "aws" {
  region = "us-east-1"
  profile = "terraform"
}

# configuracao terraform
terraform {
  required_version = ">=1.0"

    # backend terraform para armazenar o estado no S3
  backend "s3" {
    bucket  = "fnf-terraform-fmr"
    key     = "fnf-fargate.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "terraform" // ---> enable it just locally
  }

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.21.0"
    }
  }
}