output "ec2_public_ip" {
  value = module.module-ec2-linux-web.public_ip
}

output "ec2_server_id" {
  value = module.module-ec2-linux-web.server_id
}

output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = module.module-rds-db.rds_endpoint
}

output "s3_user_id" {
  value = module.module-s3.s3_user_id
}

output "s3_user_secret" {
  value     = module.module-s3.s3_user_secret
  sensitive = true
}

output "ec2_elastic_ip" {
  description = "Elastic IP attached to the EC2 instance"
  value       = aws_eip.eip.*.public_ip
}

output "ecr_user_id" {
  value = module.module-ecr.ecr_user_id
}

output "ecr_user_secret" {
  value     = module.module-ecr.ecr_user_secret
  sensitive = true
}
