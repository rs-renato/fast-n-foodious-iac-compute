data "terraform_remote_state" "lambda_state" {
  backend = "s3"
  config = {
    bucket  = "fnf-terraform-fmr"
    key     = "fnf-lambda.tfstate"
    region  = "us-east-1"
  }
}