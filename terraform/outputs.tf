output "ecr_repository_url" {
  description = "ECR repository URL: use this in the GitHub Actions workflow"
  value       = aws_ecr_repository.minecraft.repository_url
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.minecraft.id
}

output "public_ip" {
  description = "Public IP address"
  value       = aws_instance.minecraft.public_ip
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.minecraft.id
}

output "ami_id" {
  description = "AMI ID in use"
  value       = aws_instance.minecraft.ami
}

output "public_dns" {
  value = aws_instance.minecraft.public_dns
}

