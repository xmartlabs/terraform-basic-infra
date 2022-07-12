output "s3_user_id" {
  value = aws_iam_access_key.s3_user_access_key.*.id
}

output "s3_user_secret" {
  value     = aws_iam_access_key.s3_user_access_key.*.secret
  sensitive = true
}
