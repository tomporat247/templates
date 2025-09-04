output "policy_arn" {
  description = "ARN of the created IAM policy"
  value       = aws_iam_policy.wildcard_actions_policy.arn
}

output "policy_id" {
  description = "ID of the created IAM policy"
  value       = aws_iam_policy.wildcard_actions_policy.id
}

output "role_arn" {
  description = "ARN of the created IAM role"
  value       = aws_iam_role.example_role.arn
}

output "role_name" {
  description = "Name of the created IAM role"
  value       = aws_iam_role.example_role.name
}
