terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"

}