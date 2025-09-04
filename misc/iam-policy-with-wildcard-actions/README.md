# IAM Policy with Wildcard Actions

This template demonstrates how to create IAM policies using wildcard actions in AWS. It showcases various patterns of wildcard usage for different AWS services.

## Resources Created

- **IAM Policy**: A policy that demonstrates different wildcard action patterns
- **IAM Role**: An example role that can be assumed by AWS services
- **Policy Attachment**: Links the policy to the role

## Wildcard Patterns Demonstrated

1. **Full Service Wildcard**: `s3:*` - Grants all S3 permissions
2. **Action Type Wildcard**: `ec2:Describe*` - Grants all EC2 describe actions
3. **Multiple Wildcards**: `iam:Get*` and `iam:List*` - Grants specific IAM action types
4. **Scoped Wildcards**: `logs:*` with specific resource ARN patterns
5. **Resource Pattern Matching**: DynamoDB actions with table name prefixes

## Conditional Wildcard Usage

This template includes a `doNotUseWildCard` variable that allows you to switch between wildcard and specific actions:

- **When `doNotUseWildCard = false` (default)**: Uses wildcard actions as demonstrated above
- **When `doNotUseWildCard = true`**: Uses specific, explicit actions instead of wildcards for enhanced security

This feature allows you to easily toggle between broad permissions for development/testing and more restrictive permissions for production environments.

## Usage

1. Set your desired variables in terraform.tfvars or pass them via CLI
2. Run terraform commands:

```bash
terraform init
terraform plan
terraform apply
```

## Important Security Notes

⚠️ **Warning**: Wildcard actions can grant broad permissions. This template is for demonstration purposes. In production environments:

- Use the principle of least privilege
- Be specific about resources when possible
- Regularly audit wildcard permissions
- Consider using more restrictive conditions

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| aws_region | AWS region | us-east-1 |
| policy_name | Name for the IAM policy | wildcard-actions-policy |
| policy_description | Description for the IAM policy | Example IAM policy demonstrating wildcard actions usage |
| table_prefix | Prefix for DynamoDB tables | example |
| trusted_service | AWS service that can assume the role | lambda.amazonaws.com |
| doNotUseWildCard | When true, uses specific actions instead of wildcards | false |
| tags | Tags to apply to resources | See variables.tf |

## Outputs

The policy ARN and role ARN are available as outputs for use in other resources or modules.
