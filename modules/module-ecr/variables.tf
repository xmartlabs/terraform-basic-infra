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

# ECR
variable "ecr_repositories" {
  description = " list of ECR repositories"
  default     = []
}

variable "create_ecr_access_user" {
  description = "variable to define if you want to create an i am user with access to the repositories"
  default     = false
}
