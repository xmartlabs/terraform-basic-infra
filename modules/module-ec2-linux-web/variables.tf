# Generics
variable "region" {
  description = "the region where the infrastructure will be hosted (us-east-2, us-east-1, etc)"
}

variable "env" {
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
variable "device_index_network_interface" {
  description = "network interface definition"
  default     = "0"
}

variable "id_network_interface" {
  description = "network interface definition"
}

# EC2
variable "ec2name" {
  description = "name for the EC2 instance"
  default     = "EC2"
}
variable "key_name" {
  description = "key to be used by the EC2. It needs to exists"
  default     = "default-key_name"
}
variable "size" {
  description = "instance type for the EC2"
  default     = "t2.micro"
}
variable "root_disk" {
  description = "root disk definition"
  default     = [{ volume_size = "100", volume_type = "gp2" }]
}
variable "amiid" {
  description = "amiid used by the EC2 instance created"
}

# To be run after creation
variable "create_machine_script" {
  description = "path of the start machine script"
}

# To be run after creation
variable "iam_instance_profile" {
  description = "I am instace profile required in the ec2 instance"
  default     = null
}
