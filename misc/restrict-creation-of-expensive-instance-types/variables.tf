variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "instance_name" {
  description = "Name for the EC2 instance"
  type        = string
  default     = "expensive-instance-test"
}

variable "use_expensive_instance" {
  description = "When set to true, uses expensive G5 instance type. Default true for testing cost policies"
  type        = bool
  default     = true
}

variable "expensive_instance_type" {
  description = "Expensive instance type to use when testing cost restrictions"
  type        = string
  default     = "g5.2xlarge"
  validation {
    condition = contains([
      "g5.xlarge", "g5.2xlarge", "g5.4xlarge", "g5.8xlarge",
      "g5.12xlarge", "g5.16xlarge", "g5.24xlarge", "g5.48xlarge"
    ], var.expensive_instance_type)
    error_message = "Instance type must be one of the G5 family: g5.xlarge, g5.2xlarge, g5.4xlarge, g5.8xlarge, g5.12xlarge, g5.16xlarge, g5.24xlarge, g5.48xlarge."
  }
}

variable "affordable_instance_type" {
  description = "Affordable instance type to use when not testing cost restrictions"
  type        = string
  default     = "t3.small"
  validation {
    condition = contains([
      "t3.micro", "t3.small", "t3.medium", "t2.micro", "t2.small"
    ], var.affordable_instance_type)
    error_message = "Instance type must be one of the affordable options: t3.micro, t3.small, t3.medium, t2.micro, t2.small."
  }
}

variable "key_pair_name" {
  description = "Name of the AWS key pair for SSH access (must exist in the region)"
  type        = string
  default     = null
}

variable "root_volume_type" {
  description = "Type of root EBS volume"
  type        = string
  default     = "gp3"
  validation {
    condition     = contains(["gp2", "gp3", "io1", "io2"], var.root_volume_type)
    error_message = "Root volume type must be one of: gp2, gp3, io1, io2."
  }
}

variable "root_volume_size" {
  description = "Size of root EBS volume in GB"
  type        = number
  default     = 20
  validation {
    condition     = var.root_volume_size >= 8 && var.root_volume_size <= 1000
    error_message = "Root volume size must be between 8 and 1000 GB."
  }
}

variable "encrypt_root_volume" {
  description = "Whether to encrypt the root EBS volume"
  type        = bool
  default     = true
}

variable "allocate_elastic_ip" {
  description = "Whether to allocate and associate an Elastic IP"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment name (used in tags and user data)"
  type        = string
  default     = "test"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "test"
    Purpose     = "cost-policy-testing"
    Project     = "expensive-instance-restriction"
  }
}
