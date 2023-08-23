variable "env" {
  description = "the name of the environment we are managing (staging, rc, production)"
}

variable "project" {
  description = "the name of the project"
}

variable "create_ec2_iam" {
  description = "whether to create ec2 iam role"
  default = true
}

variable "create_cloudwatch_policy" {
  description = "whether to provide access to cloudwatch"
  default = true
}

variable "create_ecr_policy" {
  description = "whether to provide access to ecr"
  default = true
}

