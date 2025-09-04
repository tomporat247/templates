terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  s3_actions = var.doNotUseWildCard ? [
    "s3:GetObject",
    "s3:PutObject",
    "s3:DeleteObject",
    "s3:GetBucketLocation",
    "s3:ListBucket"
  ] : ["s3:*"]
  
  ec2_actions = var.doNotUseWildCard ? [
    "ec2:DescribeInstances",
    "ec2:DescribeImages",
    "ec2:DescribeSecurityGroups",
    "ec2:DescribeVpcs",
    "ec2:DescribeSubnets"
  ] : ["ec2:Describe*"]
  
  iam_actions = var.doNotUseWildCard ? [
    "iam:GetUser",
    "iam:GetRole",
    "iam:GetPolicy",
    "iam:ListUsers",
    "iam:ListRoles",
    "iam:ListPolicies"
  ] : ["iam:Get*", "iam:List*"]
  
  logs_actions = var.doNotUseWildCard ? [
    "logs:CreateLogGroup",
    "logs:CreateLogStream",
    "logs:PutLogEvents",
    "logs:DescribeLogGroups"
  ] : ["logs:*"]
  
  dynamodb_actions = var.doNotUseWildCard ? [
    "dynamodb:GetItem",
    "dynamodb:PutItem",
    "dynamodb:UpdateItem",
    "dynamodb:DeleteItem",
    "dynamodb:Query",
    "dynamodb:Scan"
  ] : ["dynamodb:*"]
}

resource "aws_iam_policy" "wildcard_actions_policy" {
  name        = var.policy_name
  description = var.policy_description
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = concat(
          local.s3_actions,
          local.ec2_actions,
          local.iam_actions
        )
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = local.logs_actions
        Resource = "arn:aws:logs:*:*:log-group:/aws/lambda/*"
      },
      {
        Effect = "Allow"
        Action = local.dynamodb_actions
        Resource = [
          "arn:aws:dynamodb:*:*:table/${var.table_prefix}*",
          "arn:aws:dynamodb:*:*:table/${var.table_prefix}*/index/*"
        ]
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role" "example_role" {
  name = "${var.policy_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = var.trusted_service
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  policy_arn = aws_iam_policy.wildcard_actions_policy.arn
  role       = aws_iam_role.example_role.name
}
