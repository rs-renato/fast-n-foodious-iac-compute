data "terraform_remote_state" "network_state" {
  backend = "s3"
  config = {
    bucket  = "fnf-terraform-fmr"
    key     = "fnf-network.tfstate"
    region  = "us-east-1"
  }
}
