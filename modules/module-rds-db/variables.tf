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
variable "subnet_group" {
  description = "sub net group name for rds"
  default     =  "subnet_group"
}

variable "subnet_ids" {
  description = "subnets id"
}

variable "vpc_security_group_ids" {
  description = "vpc security groups id"
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

variable "security_group_db" {
  description = "ssecurity group definition for the rds database"
  default     = [{ name = "security_group_db" , dbport = "5432" }]
}

variable "create_replica" {
  description = "boolean variable to define if you want to create RDS replica"
  default     = false
}
