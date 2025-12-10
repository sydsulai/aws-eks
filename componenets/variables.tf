variable "aws_region" {
    description = "AWS region to deploy resources"
    type        = string
}

variable "vpc_name" {
    description = "Name of the VPC"
    type        = string
}

variable "public_subnet_name" {
    description = "Name of the public subnet"
    type        = string
}

variable "private_subnet_name" {
    description = "Name of the private subnet"
    type        = string
}

variable "igw_name" {
    description = "Name of the Internet Gateway"
    type        = string
}

variable "natgw_name" {
    description = "Name of the NAT Gateway"
    type        = string
}

variable "public_subnet_route_table_name" {
    description = "Name of the public subnet route table"
    type        = string
}

variable "private_subnet_route_table_name" {
    description = "Name of the private subnet route table"
    type        = string
}

variable "vpc_cidr_block" {
    description = "CIDR block for the VPC"
    type        = string
}

variable "public_subnet_cidrs" {
    description = "CIDR block(s) for the public subnet(s)"
    type        = string
}

variable "private_subnet_cidrs" {
    description = "CIDR block(s) for the private subnet(s)"
    type        = string
}

variable "environment" {
    description = "Deployment environment (e.g., dev, prod)"
    type        = string
}

variable "tags" {
    description = "Tags to apply to resources"
    type        = map(string)
}

variable "instance_type" {
    description = "Instance type for EC2 instances"
    type        = string
}

variable "ami_id" {
    description = "AMI ID for EC2 instances"
    type        = string
}

variable "public_security_group_name" {
    description = "Security group ID for public EC2 instances"
    type        = string
}

variable "private_security_group_name" {
    description = "Security group ID for private EC2 instances"
    type        = string
}

variable "public_ec2_name" {
    description = "Name for public EC2 instance"
    type        = string
}

variable "private_ec2_name" {
    description = "Name for private EC2 instance"
    type        = string
}

variable "dhcp_option_set_name" {
    description = "Name for the DHCP option set"
    type        = string
}

variable "domain_name" {
    description = "Domain name for the Route private 53 hosted zone"
    type        = string
}

variable "domain_name_servers" {
    description = "Domain name servers for the Route private 53 hosted zone"
    type        = list(string)
}

variable "eks_pod_identity_role_action" {
    description = "Actions for the EKS pod identity role"
    type        = list(string)
}

variable "access_secret_policy_actions" {
    description = "Actions for accessing secrets in Secrets Manager"
    type        = list(string)
}

variable "eks_rds_db_sg_name" {
    description = "Security group name for EKS RDS Database"
    type        = string
}

variable "eks_rds_db_subnetgroup_name" {    
    description = "Subnet group name for EKS RDS Database"
    type        = string
}

variable "rds_db_instance_identifier" {
    description = "RDS DB instance identifier"
    type        = string
}

variable "rds_db_name" {
    description = "Name of the RDS database"
    type        = string
}

variable "rds_db_username" {
    description = "Username for the RDS database"
    type        = string
}

variable "rds_db_password" {
    description = "Password for the RDS database"
    type        = string
}

variable "rds_db_engine_version" {
    description = "Database engine for RDS"
    type        = string
}

variable "rds_db_instance_class" {
    description = "Instance class for RDS"
    type        = string
}

variable "rds_db_engine_name" {
    description = "Database engine name for RDS"
    type        = string
}

variable "rds_db_allocated_storage" {
    description = "Allocated storage size for RDS in GB"
    type        = number
    default     = 10
}