terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.51.1"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
   access_key = "AKIAUHQSU2XRKTTZFQ7J"
  secret_key = "dOu3PPh0QGS792DOal7z4B0OwqMMHutQXh6xHCe"
}