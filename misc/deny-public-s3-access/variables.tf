variable "aws_region" {
  description = "AWS region where S3 buckets will be created"
  type        = string
  default     = "us-east-1"
}

variable "bucket_prefix" {
  description = "Prefix for S3 bucket names"
  type        = string
  default     = "opa-test-public-access"
}

variable "enable_public_access" {
  description = "When set to true, enables public access configurations that should trigger OPA policy. Default true for policy testing"
  type        = bool
  default     = true
}

variable "public_acl_type" {
  description = "Type of public ACL to use when testing (should trigger OPA policy)"
  type        = string
  default     = "public-read"
  validation {
    condition = contains([
      "public-read", "public-read-write"
    ], var.public_acl_type)
    error_message = "Public ACL type must be either 'public-read' or 'public-read-write'."
  }
}

variable "attach_public_policy" {
  description = "Whether to attach a bucket policy that allows public access"
  type        = bool
  default     = true
}

variable "create_secondary_bucket" {
  description = "Create a secondary bucket for testing multiple bucket scenarios"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all S3 resources"
  type        = map(string)
  default = {
    Environment = "test"
    Purpose     = "opa-policy-testing"
    Project     = "s3-public-access-denial"
    Owner       = "security-team"
  }
}
