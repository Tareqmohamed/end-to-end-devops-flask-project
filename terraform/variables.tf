variable "region" {
  description = "The AWS region to deploy resources"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet1_cidr" {
  description = "CIDR block for Public Subnet 1"
  default     = "10.0.1.0/24"
}



variable "availability_zones" {
  description = "Availability zones for the subnets"
  default     = ["us-east-1a"]
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  default     = "ami-0e86e20dae9224db8"
}

variable "instance_type" {
  description = "The type of EC2 instance"
  default     = "t3.micro"
}

variable "ansible_path" {
  default = "/mnt/Cracows/depi/projects/end-to-end-falsk-devops/ansible"
}