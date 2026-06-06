variable "onid" {
  description = "ONID used for tagging"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (SUSE Linux in us-east-1)"
  type        = string
  default     = "ami-0b12a86a613a04fc6"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.large"
}

variable "key_name" {
  description = "Name of the SSH key pair (must already exist in AWS)"
  type        = string
}

variable "world_bucket_name" {
  description = "S3 bucket for Minecraft world backups"
  type        = string
}
