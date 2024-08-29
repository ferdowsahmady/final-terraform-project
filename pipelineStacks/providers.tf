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

# resource "aws_dynamodb_table" "dynamodb-terraform-lock" {
#    name = "terraform-lock"
#    hash_key = "LockID"
#    read_capacity = 20
#    write_capacity = 20

#    attribute {
#       name = "LockID"
#       type = "S"
#    }
# }
terraform {
  backend "s3" {
    bucket  = "terraform-state-file-code-killers"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    dynamodb_table = "terraform-state-lock"
  }
}