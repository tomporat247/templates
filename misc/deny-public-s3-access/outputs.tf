output "primary_bucket_name" {
  description = "Name of the primary S3 bucket"
  value       = aws_s3_bucket.test_bucket.id
}

output "primary_bucket_arn" {
  description = "ARN of the primary S3 bucket"
  value       = aws_s3_bucket.test_bucket.arn
}

output "primary_bucket_domain_name" {
  description = "Domain name of the primary S3 bucket"
  value       = aws_s3_bucket.test_bucket.bucket_domain_name
}

output "secondary_bucket_name" {
  description = "Name of the secondary S3 bucket (if created)"
  value       = var.create_secondary_bucket ? aws_s3_bucket.secondary_test_bucket[0].id : null
}

output "secondary_bucket_arn" {
  description = "ARN of the secondary S3 bucket (if created)"
  value       = var.create_secondary_bucket ? aws_s3_bucket.secondary_test_bucket[0].arn : null
}

output "bucket_acl_configuration" {
  description = "ACL configuration applied to the buckets"
  value = {
    primary_acl   = aws_s3_bucket_acl.test_bucket_acl.acl
    secondary_acl = var.create_secondary_bucket ? aws_s3_bucket_acl.secondary_bucket_acl[0].acl : null
  }
}

output "public_access_block_settings" {
  description = "Public access block settings for the primary bucket"
  value = {
    block_public_acls       = aws_s3_bucket_public_access_block.test_bucket_pab.block_public_acls
    block_public_policy     = aws_s3_bucket_public_access_block.test_bucket_pab.block_public_policy
    ignore_public_acls      = aws_s3_bucket_public_access_block.test_bucket_pab.ignore_public_acls
    restrict_public_buckets = aws_s3_bucket_public_access_block.test_bucket_pab.restrict_public_buckets
  }
}

output "bucket_policy_attached" {
  description = "Whether a bucket policy is attached and what type"
  value = {
    policy_attached = var.attach_public_policy
    policy_type     = var.enable_public_access ? "public-access-policy" : "deny-insecure-transport-policy"
  }
}

output "opa_policy_test_results" {
  description = "Expected OPA policy test results for this configuration"
  value = {
    should_be_blocked = var.enable_public_access
    compliance_mode   = var.enable_public_access ? "non-compliant" : "compliant"
    expected_behavior = var.enable_public_access ? "OPA should DENY this configuration" : "OPA should ALLOW this configuration"
    
    # Specific OPA rule triggers
    triggers_acl_rule = var.enable_public_access && contains(["public-read", "public-read-write"], local.selected_acl)
    triggers_policy_rule = var.enable_public_access && var.attach_public_policy
    triggers_public_access_block_rules = var.enable_public_access
    
    # Expected error messages from OPA policy
    expected_opa_errors = var.enable_public_access ? [
      "${aws_s3_bucket_acl.test_bucket_acl.bucket}: public S3 bucket ACL (${local.selected_acl})",
      var.attach_public_policy ? "${try(aws_s3_bucket_policy.test_bucket_policy[0].bucket, "bucket-policy")}: bucket policy allows public access" : null,
      "${aws_s3_bucket_public_access_block.test_bucket_pab.bucket}: S3 bucket must enable 'block_public_acls'",
      "${aws_s3_bucket_public_access_block.test_bucket_pab.bucket}: S3 bucket must enable 'block_public_policy'",
      "${aws_s3_bucket_public_access_block.test_bucket_pab.bucket}: S3 bucket must enable 'ignore_public_acls'",
      "${aws_s3_bucket_public_access_block.test_bucket_pab.bucket}: S3 bucket must enable 'restrict_public_buckets'"
    ] : []
  }
}

output "resource_addresses" {
  description = "Terraform resource addresses that should be checked by OPA policy"
  value = {
    bucket_acl_address = "aws_s3_bucket_acl.test_bucket_acl"
    bucket_policy_address = var.attach_public_policy ? "aws_s3_bucket_policy.test_bucket_policy[0]" : null
    public_access_block_address = "aws_s3_bucket_public_access_block.test_bucket_pab"
    secondary_bucket_acl_address = var.create_secondary_bucket ? "aws_s3_bucket_acl.secondary_bucket_acl[0]" : null
    secondary_public_access_block_address = var.create_secondary_bucket ? "aws_s3_bucket_public_access_block.secondary_bucket_pab[0]" : null
  }
}

output "testing_instructions" {
  description = "Instructions for testing with OPA policy"
  value = {
    step1 = "Run 'terraform plan' to generate plan file"
    step2 = "Save plan as JSON: 'terraform show -json tfplan > plan.json'"
    step3 = "Test with OPA: 'opa eval -d policy.rego -i plan.json \"data.env0.deny[x]\""
    step4 = var.enable_public_access ? "Expected: OPA should return multiple deny messages" : "Expected: OPA should return empty result (no denials)"
  }
}
