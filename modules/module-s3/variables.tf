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

#S3
variable "bucket" {
  description = "definition of the s3 bucket"
  default     = [{ bucket = "terraform_bucket ", acl = "private" }]
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
