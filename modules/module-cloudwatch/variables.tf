# Generics
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

#  Cloudwatch
variable "cloudwatch_log_group" {
  description = "cloudwatch default log group name"
  default     = "docker-logs"
}

variable "use_cloudwatch_for_logging" {
  description = "boolean variable to enable the cloudwatch usage for logs storage"
  default     = false
}

variable "use_cloudwatch_for_monitoring" {
  description = "boolean variable to enable the cloudwatch usage for instance monitoring"
  default     = false
}

variable "ec2_instance_id" {
  description = "id of the ec2 instance"
}

variable "notification_email_list" {
  description = "notification email list to send alarms notifications"
  default     = []
}
