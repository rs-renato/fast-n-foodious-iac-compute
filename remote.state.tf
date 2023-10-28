data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket         = "fnf-terraform-network"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}
