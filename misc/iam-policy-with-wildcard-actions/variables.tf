variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "policy_name" {
  description = "Name for the IAM policy"
  type        = string
  default     = "wildcard-actions-policy"
}

variable "policy_description" {
  description = "Description for the IAM policy"
  type        = string
  default     = "Example IAM policy demonstrating wildcard actions usage"
}

variable "table_prefix" {
  description = "Prefix for DynamoDB tables that this policy can access"
  type        = string
  default     = "example"
}

variable "trusted_service" {
  description = "AWS service that can assume the IAM role"
  type        = string
  default     = "lambda.amazonaws.com"
}

variable "tags" {
  description = "Tags to apply to IAM resources"
  type        = map(string)
  default = {
    Environment = "demo"
    Purpose     = "wildcard-actions-example"
  }
}
