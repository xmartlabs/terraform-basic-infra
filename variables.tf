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
  description = "boolean variable to include the prefix '{var.project}_{var.env}' in all the resourse names."
  default     = true
}

# Networking
variable "vpc" {
  description = "the definition of the VPC"
  default     = [{ name = "vpc", cidr_block = "10.0.0.0/16", instance_tenancy = "default", enable_dns_hostnames = true, enable_dns_support = true }]
}

variable "subnet_public" {
  description = "the definition of the public subnet"
  default     = [{ name = "subnet_public", cidr_block = "10.0.1.0/24", availability_zone = "sa-east-1a", map_public_ip_on_launch = true }]
}

variable "subnet_private_1" {
  description = "the definition of the private subnet 1"
  default     = [{ name = "subnet_private_1", cidr_block = "10.0.2.0/24", availability_zone = "sa-east-1a", map_public_ip_on_launch = true }]
}

variable "subnet_private_2" {
  description = "he definition of the private subnet 2"
  default     = [{ name = "subnet_private_2", cidr_block = "10.0.3.0/24", availability_zone = "sa-east-1b", map_public_ip_on_launch = false }]
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

variable "subnet_group" {
  description = "sub net group name for rds"
  default     =  "subnet_group"
} 

# EC2
variable "ec2name" {
  description = "name for the EC2 instance"
}

variable "key_name" {
  description = "key to be used by the EC2. It needs to exists"
}

variable "size" {
  description = "instance type for the EC2"
}

variable "root_disk" {
  description = "root disk definition"
}

variable "amiid" {
  description = "amiid used by the EC2 instance created"
}

## To be run after creation
variable "create_machine_script" {
  description = "path of the start machine script"
  default     = "create_machine_script.tmpl"
} 

# RDS
variable "rds-master" {
  description = "the definition of the RDS database"
  default     =  [{ Name = "db-master" , engine = "postgres", engine_version = "13.4" , instance_class = "db.t2.micro" ,allocated_storage = 5,family = "postgres11"}]
} 

variable "rds-replica" {
  description = "the definition of the RDS read replica database"
  default     =  [{ Name = "db-replica" }]
} 

variable "db-name" {
  description = "data base name"
} 

variable "secret_password_id" {
  description = "name of the secret where the RDS password is stored. It needs to exist"
}

variable "create_replica" {
  description = "boolean variable to define if you want to create RDS replica"
  default     = false
}

# S3
variable "bucket" {
  description = "definition of the s3 bucket"
  default     = [{ bucket = "bucket ", acl = "private" }]
}

variable "cors_rule" {
  description = "definition of the cors rules applied to the created bucket"
  default     = [{allowed_methods = ["GET"], allowed_origins = ["*"], max_age_seconds = 3000}]
}

variable "policy" {
  description = "definition of the policy applied to the created bucket"
   default    = [{Sid = "PublicListGet", Effect = "Allow", Principal = "*"}]
}

variable "action_policy" {
   description = "definition of the action policy applied to the created bucket"
   default     = ["s3:GetObject"]
}

variable "create_bucket_access_user" {
  description = "variable to define if you want to create an i am user with access to the bucket"
  default     = false
}

# Elastic IP
variable "create_elastic_ip" {
  description = "variable to define if you want to create an elastic ip for the EC2 instance"
  default     = false
}

# AWS Cloudwatch
variable "cloudwatch_log_group" {
  description = "cloudwatch default log group name"
  default     = "docker-logs"
}

variable "use_cloudwatch_for_logging" {
  description = "boolean variable to enable the cloudwatch usage for logs storage"
  default     = false
}

# AWS Simple email Service
variable "enable_aws_ses" {
  description = "variable to enable the aws ses configuration"
  default     = false
}

variable "aws_ses_email_sender" {
  description = "variable to set the configured aws ses sender"
  default     = "example@domain.com"
}

# ECR
variable "ecr_repositories" {
  description = "list of ECR repositories"
  default     = []
}

variable "create_ecr_access_user" {
  description = "variable to define if you want to create an i am user with access to the repositories"
  default     = false
}
