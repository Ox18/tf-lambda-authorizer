terraform {
  backend "s3" {
    bucket = "golandia"
    encrypt = true
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
}