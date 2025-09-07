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
  expensive_instance_types = [
    "g5.xlarge",
    "g5.2xlarge",
    "g5.4xlarge",
    "g5.8xlarge",
    "g5.12xlarge",
    "g5.16xlarge",
    "g5.24xlarge",
    "g5.48xlarge"
  ]
  
  affordable_instance_types = [
    "t3.micro",
    "t3.small",
    "t3.medium"
  ]
  
  selected_instance_type = var.use_expensive_instance ? var.expensive_instance_type : var.affordable_instance_type
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = data.aws_availability_zones.available.names[0]
  default_for_az    = true
}

resource "aws_security_group" "expensive_instance_sg" {
  name_prefix = "${var.instance_name}-sg"
  description = "Security group for expensive instance testing"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.instance_name}-sg"
  })
}

resource "aws_instance" "expensive_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = local.selected_instance_type
  subnet_id              = data.aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.expensive_instance_sg.id]
  key_name               = var.key_pair_name

  user_data = base64encode(templatefile("${path.module}/user-data.sh.tftpl", {
    instance_name = var.instance_name
    environment   = var.environment
  }))

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = var.encrypt_root_volume
  }

  tags = merge(var.tags, {
    Name = var.instance_name
    Type = "expensive-instance-test"
    Cost = var.use_expensive_instance ? "high" : "low"
  })
}

resource "aws_eip" "instance_eip" {
  count = var.allocate_elastic_ip ? 1 : 0

  instance = aws_instance.expensive_instance.id
  domain   = "vpc"

  tags = merge(var.tags, {
    Name = "${var.instance_name}-eip"
  })
}
