terraform {
  required_version = ">= 0.14"
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
  bucket_name = "${var.bucket_prefix}-${random_string.bucket_suffix.result}"
  
  # Non-compliant (default) - should trigger OPA policy
  non_compliant_acl = var.public_acl_type
  
  # Compliant ACL
  compliant_acl = "private"
  
  # Selected ACL based on compliance mode
  selected_acl = var.enable_public_access ? local.non_compliant_acl : local.compliant_acl
  
  # Public access block settings
  public_access_block = var.enable_public_access ? {
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
  } : {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}

resource "random_string" "bucket_suffix" {
  length  = 8
  upper   = false
  special = false
}

resource "aws_s3_bucket" "test_bucket" {
  bucket        = local.bucket_name
  force_destroy = true

  tags = merge(var.tags, {
    Name        = local.bucket_name
    Purpose     = "public-access-policy-testing"
    Compliance  = var.enable_public_access ? "non-compliant" : "compliant"
    PolicyTest  = "deny-public-s3-access"
  })
}

# This resource should trigger OPA policy when using public ACLs
resource "aws_s3_bucket_acl" "test_bucket_acl" {
  bucket     = aws_s3_bucket.test_bucket.id
  acl        = local.selected_acl
  depends_on = [aws_s3_bucket_ownership_controls.test_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "test_bucket_acl_ownership" {
  bucket = aws_s3_bucket.test_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# This resource should trigger OPA policy when allowing public access
resource "aws_s3_bucket_policy" "test_bucket_policy" {
  count  = var.attach_public_policy ? 1 : 0
  bucket = aws_s3_bucket.test_bucket.id

  policy = var.enable_public_access ? jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.test_bucket.arn}/*"
      }
    ]
  }) : jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyPublicAccess"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:*"
        Resource = [
          aws_s3_bucket.test_bucket.arn,
          "${aws_s3_bucket.test_bucket.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

# This resource should trigger OPA policy when not blocking public access
resource "aws_s3_bucket_public_access_block" "test_bucket_pab" {
  bucket = aws_s3_bucket.test_bucket.id

  block_public_acls       = local.public_access_block.block_public_acls
  block_public_policy     = local.public_access_block.block_public_policy
  ignore_public_acls      = local.public_access_block.ignore_public_acls
  restrict_public_buckets = local.public_access_block.restrict_public_buckets
}

# Additional bucket for testing multiple bucket scenario
resource "aws_s3_bucket" "secondary_test_bucket" {
  count         = var.create_secondary_bucket ? 1 : 0
  bucket        = "${local.bucket_name}-secondary"
  force_destroy = true

  tags = merge(var.tags, {
    Name       = "${local.bucket_name}-secondary"
    Purpose    = "secondary-bucket-policy-testing"
    Compliance = var.enable_public_access ? "non-compliant" : "compliant"
    PolicyTest = "deny-public-s3-access"
  })
}

resource "aws_s3_bucket_acl" "secondary_bucket_acl" {
  count      = var.create_secondary_bucket ? 1 : 0
  bucket     = aws_s3_bucket.secondary_test_bucket[0].id
  acl        = var.enable_public_access ? "public-read-write" : "private"
  depends_on = [aws_s3_bucket_ownership_controls.secondary_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "secondary_bucket_acl_ownership" {
  count  = var.create_secondary_bucket ? 1 : 0
  bucket = aws_s3_bucket.secondary_test_bucket[0].id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "secondary_bucket_pab" {
  count  = var.create_secondary_bucket ? 1 : 0
  bucket = aws_s3_bucket.secondary_test_bucket[0].id

  block_public_acls       = var.enable_public_access ? false : true
  block_public_policy     = var.enable_public_access ? false : true
  ignore_public_acls      = var.enable_public_access ? false : true
  restrict_public_buckets = var.enable_public_access ? false : true
}
