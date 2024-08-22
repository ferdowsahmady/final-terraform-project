provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket  = "terraform-state-file-code-killers"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    # dynamodb_table = "terraform-state-lock"
  }
}