data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket         = "fnf-tf-network"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}

data "terraform_remote_state" "storage" {
  backend = "s3"
  config = {
    bucket         = "fnf-tf-storage"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}
