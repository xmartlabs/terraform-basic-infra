# Generics
variable "region" {
  description = "the region where the infrastructure will be hosted (us-east-2, us-east-1, etc)"
}

variable "env"  {
  description = "the name of the environment we are managing (staging, rc, production)"
}

variable "project" {
  description = "the name of the project"
}

variable "create_prefix_for_resources" {
  description = "boolean variable to include the prefix 'var.project_var.env' in all the resourse names."
  default     = true
}

# Networking
variable "vpc" {
  description = "the definition of the VPC"
  default     = [{ name = "vpc", cidr_block = "10.0.0.0/16", instance_tenancy = "default", enable_dns_hostnames = true, enable_dns_support = true }]
}

variable "subnet_public" {
  description = "the definition of the public subnet"
  default     = [{ name = "subnet_public", cidr_block = "10.0.1.0/24", availability_zone = "us-east-1a", map_public_ip_on_launch = true }]
}

variable "subnet_private_1" {
  description = "the definition of the private subnet 1"
  default     = [{ name = "subnet_private_1", cidr_block = "10.0.2.0/24", availability_zone = "us-east-1a", map_public_ip_on_launch = true }]
}

variable "subnet_private_2" {
  description = "the definition of the private subnet 2"
  default     = [{ name = "subnet_private_2", cidr_block = "10.0.3.0/24", availability_zone = "us-east-1b", map_public_ip_on_launch = false }]
}

variable "security_group_web" {
  description = "security group definition for the EC2 instance"
  default     = [{ name = "security_group_web" }]
}

variable "security_group_db" {
  description = "security group definition for the rds database"
  default     = [{ name = "security_group_db" , dbport = "5432" }]
}

variable "route_table" {
  description = "route table definition"
  default     = [{ name = "route_table", cidr_block = "0.0.0.0/0", ipv6_cidr_block = "::/0" }]
}

variable "network_interface" {
  description = "network interface definition"
  default     = [{ name = "network_interface", private_ips = ["10.0.1.50"], device_index = 0 }]
}
