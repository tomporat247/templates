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

resource "aws_iam_policy" "wildcard_actions_policy" {
  name        = var.policy_name
  description = var.policy_description
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "ec2:Describe*",
          "iam:Get*",
          "iam:List*"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:*"
        ]
        Resource = "arn:aws:logs:*:*:log-group:/aws/lambda/*"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:*"
        ]
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
