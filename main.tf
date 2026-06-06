terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  # If you configured a named profile above, add: profile = "cs312"
  profile = "cs312"
}

# Use the default VPC instead of creating a new one
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name = "map-public-ip-on-launch"
    values = ["true"]
  }
}

locals {
  selected_subnet_id = data.aws_subnets.public.ids[0]
}


resource "aws_instance" "minecraft" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = local.selected_subnet_id
  vpc_security_group_ids = [aws_security_group.minecraft.id]
  iam_instance_profile   = "LabInstanceProfile"
  associate_public_ip_address = true
  user_data = file("${path.module}/cloud-init.yaml")

  tags = {
    Name  = "minecraft-tf-${var.onid}"
    Owner = var.onid
  }
}

resource "aws_security_group" "minecraft" {
  name        = "minecraft-tf-sg-${var.onid}"
  description = "minecraft-tf security group"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom TCP"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "minecraft-tf-sg-${var.onid}"
    Owner = var.onid
  }
}



# ECR repository for the CI/CD pipeline in Lab 6
resource "aws_ecr_repository" "minecraft" {
  name                 = "misttryh-mine"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}
