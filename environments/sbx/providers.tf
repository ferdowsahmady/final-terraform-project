provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Project = "Terraform-Final-Project"
      Team    = "Code-Killers"
      Class   = "026DO"
    }
  }
}

terraform {
  backend "s3" {
    bucket  = "ferdows-rady-s3" #"terraform-state-file-code-killers"
    key     = "terraform.tfstate"
    region  = "us-east-1"
<<<<<<< HEAD
    # encrypt = true
=======
    encrypt = true
>>>>>>> 351e239a72845da88a6eac0fd81318b0d58108dc
    # dynamodb_table = "terraform-state-lock"
  }
}