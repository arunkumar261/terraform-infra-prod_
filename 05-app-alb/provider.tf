terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
       backend "s3" {
    bucket = "roboshop-state-prod"   
    key    = "infra-app-alb"
    region = "us-east-1"
    dynamodb_table = "roboshop-locking-prod"   
  }
}

provider "aws" {
   region = "us-east-1"

}
