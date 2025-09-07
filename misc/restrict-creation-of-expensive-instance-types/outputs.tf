output "instance_id" {
  description = "ID of the created EC2 instance"
  value       = aws_instance.expensive_instance.id
}

output "instance_arn" {
  description = "ARN of the created EC2 instance"
  value       = aws_instance.expensive_instance.arn
}

output "instance_type" {
  description = "Instance type used"
  value       = aws_instance.expensive_instance.instance_type
}

output "instance_state" {
  description = "State of the EC2 instance"
  value       = aws_instance.expensive_instance.instance_state
}

output "public_ip" {
  description = "Public IP address of the instance"
  value       = aws_instance.expensive_instance.public_ip
}

output "private_ip" {
  description = "Private IP address of the instance"
  value       = aws_instance.expensive_instance.private_ip
}

output "public_dns" {
  description = "Public DNS name of the instance"
  value       = aws_instance.expensive_instance.public_dns
}

output "elastic_ip" {
  description = "Elastic IP address (if allocated)"
  value       = var.allocate_elastic_ip ? aws_eip.instance_eip[0].public_ip : null
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.expensive_instance_sg.id
}

output "availability_zone" {
  description = "Availability zone where the instance is running"
  value       = aws_instance.expensive_instance.availability_zone
}

output "key_name" {
  description = "Key pair name used for the instance"
  value       = aws_instance.expensive_instance.key_name
}

output "root_volume_id" {
  description = "ID of the root EBS volume"
  value       = aws_instance.expensive_instance.root_block_device[0].volume_id
}

output "estimated_monthly_cost" {
  description = "Estimated monthly cost warning for the instance type"
  value = var.use_expensive_instance ? {
    instance_type = local.selected_instance_type
    warning = "This G5 instance type can cost $200-$5000+ per month!"
    recommendation = "Use for testing cost policies only, terminate when done"
  } : {
    instance_type = local.selected_instance_type
    cost = "This instance type costs approximately $10-50 per month"
  }
}
