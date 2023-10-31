data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket         = "fast-n-foodious-terraform-network"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}

data "terraform_remote_state" "storage" {
  backend = "s3"
  config = {
    bucket         = "fast-n-foodious-terraform-storage"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}
