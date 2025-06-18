terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Get information about the current AWS user
data "aws_caller_identity" "current" {}

# Output the current AWS user information
output "aws_user_id" {
  value = data.aws_caller_identity.current.user_id
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_arn" {
  value = data.aws_caller_identity.current.arn
}
