terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.75.2"
    }
  }
}
provider "aws" {
   profile = "default"
   region  = var.region
}
