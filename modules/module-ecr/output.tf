output "ecr_user_id" {
  value = aws_iam_access_key.ecr_user_access_key.*.id
}

output "ecr_user_secret" {
  value     = aws_iam_access_key.ecr_user_access_key.*.secret
  sensitive = true
}
