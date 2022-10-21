terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    bucket = "<your-account>-tfstate"
    key    = "terraform.tfstate"
    region = "sa-east-1"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9.0"
    }
  }
}

provider "aws" {
  region = var.region
}
