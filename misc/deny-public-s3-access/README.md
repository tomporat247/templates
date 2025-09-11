# Deny Public S3 Access - OPA Policy Test Template

This template creates AWS S3 resources that **intentionally violate public access policies** to test OPA (Open Policy Agent) rules that prevent public S3 bucket configurations.

## Purpose

This template is designed to test the provided OPA policy that checks for:
1. **Public S3 bucket ACLs** (`public-read`, `public-read-write`)
2. **Public S3 bucket policies** (Principal = "*")
3. **Missing public access block settings** (all 4 settings must be enabled)

## OPA Policy Being Tested

The template tests this specific OPA policy:
```rego
package env0

# Deny public ACLs
deny[msg] {
  rc := input.plan.resource_changes[_]
  rc.type == "aws_s3_bucket_acl"
  a := rc.change.after
  a.acl == "public-read"
  msg := sprintf("%s: public S3 bucket ACL (%s)", [rc.address, a.acl])
}

# Deny public bucket policies  
deny[msg] {
  rc := input.plan.resource_changes[_]
  rc.type == "aws_s3_bucket_policy"
  a := rc.change.after
  json.unmarshal(a.policy, pol)
  st := pol.Statement[_]
  lower(st.Effect) == "allow"
  is_public(st.Principal)
  msg := sprintf("%s: bucket policy allows public access", [rc.address])
}

# Deny missing public access block settings
deny[msg] {
    r := input.plan.resource_changes[_]
    r.type == "aws_s3_bucket_public_access_block"
    r.change.after.block_public_acls != true
    msg := sprintf("%s: S3 bucket must enable 'block_public_acls'", [r.address])
}
```

## Resources Created

- **Primary S3 Bucket**: Main test bucket with configurable public access
- **Secondary S3 Bucket** (optional): Additional bucket for multi-bucket testing
- **S3 Bucket ACL**: Configurable ACL (public-read/public-read-write by default)
- **S3 Bucket Policy**: Public access policy (when enabled)
- **S3 Public Access Block**: Configurable public access blocking settings
- **S3 Bucket Ownership Controls**: Required for ACL functionality in modern AWS

## Conditional Public Access Control

This template includes an `enable_public_access` variable that controls compliance:

- **When `enable_public_access = true` (default)**: Creates non-compliant configuration that should trigger OPA denials
- **When `enable_public_access = false`**: Creates compliant configuration that should pass OPA validation

### Non-Compliant Configuration (Default):
- **ACL**: `public-read` or `public-read-write`
- **Bucket Policy**: Allows public read access with Principal "*"
- **Public Access Block**: All settings set to `false`

### Compliant Configuration:
- **ACL**: `private`
- **Bucket Policy**: Denies insecure transport only
- **Public Access Block**: All settings set to `true`

## Usage

### Basic Testing (Non-Compliant)
```bash
terraform init
terraform plan -out=tfplan
terraform show -json tfplan > plan.json

# Test with OPA
opa eval -d policy.rego -i plan.json "data.env0.deny[x]"
```

### Testing Compliant Configuration
```bash
terraform plan -var="enable_public_access=false" -out=tfplan
terraform show -json tfplan > plan.json

# Test with OPA (should return empty result)
opa eval -d policy.rego -i plan.json "data.env0.deny[x]"
```

### Testing Individual Public Access Block Properties
```bash
# Test ONLY block_public_acls misconfigured (other 3 properties compliant)
terraform plan -var="misconfigure_single_property=block_public_acls" -out=tfplan

# Test ONLY block_public_policy misconfigured  
terraform plan -var="misconfigure_single_property=block_public_policy" -out=tfplan

# Test ONLY ignore_public_acls misconfigured
terraform plan -var="misconfigure_single_property=ignore_public_acls" -out=tfplan

# Test ONLY restrict_public_buckets misconfigured
terraform plan -var="misconfigure_single_property=restrict_public_buckets" -out=tfplan
```

### Testing Different Public ACL Types
```bash
# Test with public-read-write ACL
terraform plan -var="public_acl_type=public-read-write" -out=tfplan

# Test without bucket policy
terraform plan -var="attach_public_policy=false" -out=tfplan

# Test single bucket only
terraform plan -var="create_secondary_bucket=false" -out=tfplan
```

## Expected OPA Results

### Non-Compliant Mode (default):
OPA should return multiple deny messages:
- `aws_s3_bucket_acl.test_bucket_acl: public S3 bucket ACL (public-read)`
- `aws_s3_bucket_policy.test_bucket_policy[0]: bucket policy allows public access`
- `aws_s3_bucket_public_access_block.test_bucket_pab: S3 bucket must enable 'block_public_acls'`
- `aws_s3_bucket_public_access_block.test_bucket_pab: S3 bucket must enable 'block_public_policy'`
- `aws_s3_bucket_public_access_block.test_bucket_pab: S3 bucket must enable 'ignore_public_acls'`
- `aws_s3_bucket_public_access_block.test_bucket_pab: S3 bucket must enable 'restrict_public_buckets'`

### Compliant Mode:
OPA should return empty result (no deny messages).

### Single Property Misconfiguration:
When using `misconfigure_single_property`, OPA should return exactly ONE deny message:
- `misconfigure_single_property=block_public_acls` → `"S3 bucket must enable 'block_public_acls'"`
- `misconfigure_single_property=block_public_policy` → `"S3 bucket must enable 'block_public_policy'"`
- `misconfigure_single_property=ignore_public_acls` → `"S3 bucket must enable 'ignore_public_acls'"`
- `misconfigure_single_property=restrict_public_buckets` → `"S3 bucket must enable 'restrict_public_buckets'"`

This validates that each OPA rule works independently.

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| aws_region | AWS region for S3 buckets | us-east-1 |
| bucket_prefix | Prefix for S3 bucket names | opa-test-public-access |
| enable_public_access | Enable public access (triggers OPA policy) | true |
| public_acl_type | Type of public ACL to test | public-read |
| attach_public_policy | Attach public bucket policy | true |
| create_secondary_bucket | Create secondary bucket for testing | true |
| misconfigure_single_property | Misconfigure only one public access block property | null |

## Testing Scenarios

1. **Full Non-Compliance Testing**: Default configuration tests all OPA rules
2. **Specific ACL Testing**: Test different public ACL types
3. **Policy-Only Testing**: Test bucket policies without public ACLs
4. **Public Access Block Testing**: Test individual public access block settings
5. **Multi-Bucket Testing**: Verify OPA catches violations across multiple buckets
6. **Compliance Validation**: Ensure compliant configurations pass OPA

## Integration with OPA

### Policy File Setup:
1. Save the provided OPA policy as `policy.rego`
2. Place it in your OPA policy directory

### Testing Workflow:
```bash
# 1. Generate Terraform plan
terraform plan -out=tfplan

# 2. Convert plan to JSON
terraform show -json tfplan > plan.json

# 3. Test with OPA
opa eval -d policy.rego -i plan.json "data.env0.deny[x]"

# 4. Verify expected results match actual OPA output
```

### CI/CD Integration:
```bash
#!/bin/bash
# Example CI/CD script
terraform plan -out=tfplan
terraform show -json tfplan > plan.json

# Run OPA test
opa_result=$(opa eval -d policy.rego -i plan.json "data.env0.deny[x]")

if [ -n "$opa_result" ]; then
  echo "OPA policy violations detected:"
  echo "$opa_result"
  exit 1
else
  echo "No OPA policy violations found"
fi
```

## Cleanup

```bash
terraform destroy
```

## Security Notes

⚠️ **Important**: This template creates intentionally insecure S3 configurations by default:
- Only use in test environments
- Never apply with `enable_public_access=true` in production
- Always destroy resources after testing
- Monitor AWS costs as S3 operations may incur charges

## Output Information

The template provides comprehensive outputs including:
- **Bucket information**: Names, ARNs, and configuration details
- **OPA test results**: Expected policy behavior and error messages
- **Resource addresses**: Terraform resource identifiers for OPA matching
- **Testing instructions**: Step-by-step guide for OPA testing

Use the `opa_policy_test_results` output to understand expected OPA behavior before running tests.
