
################################################################################
# Network
################################################################################

module "module-network-linux-web-db" {
  source  = "./modules/module-network-linux-web-db"
  region  = var.region
  project = var.project
  env     = var.env

  vpc = var.vpc

  route_table       = var.route_table
  network_interface = var.network_interface

  subnet_public    = var.subnet_public
  subnet_private_1 = var.subnet_private_1
  subnet_private_2 = var.subnet_private_2


  security_group_web          = var.security_group_web
  security_group_db           = var.security_group_db
  create_prefix_for_resources = var.create_prefix_for_resources
}

################################################################################
# EC2
################################################################################

module "module-ec2-linux-web" {
  source                      = "./modules/module-ec2-linux-web"
  region                      = var.region
  amiid                       = var.amiid
  env                         = var.env
  project                     = var.project
  id_network_interface        = module.module-network-linux-web-db.network_interface_id
  create_machine_script       = var.create_machine_script
  key_name                    = var.key_name
  ec2name                     = var.ec2name
  size                        = var.size
  root_disk                   = var.root_disk
  iam_instance_profile        = var.use_cloudwatch_for_logging || var.use_cloudwatch_for_monitoring ? module.module-cloudwatch.cloudwatch_profile_name[0] : null
  create_prefix_for_resources = var.create_prefix_for_resources
}

################################################################################
# ELASTIC IP
################################################################################

resource "aws_eip" "eip" {
  count    = var.create_elastic_ip ? 1 : 0
  instance = module.module-ec2-linux-web.server_id
  vpc      = true
}

################################################################################
# RDS Database
################################################################################

module "module-rds-db" {
  source                      = "./modules/module-rds-db"
  region                      = var.region
  env                         = var.env
  project                     = var.project
  subnet_group                = var.subnet_group
  subnet_ids                  = [module.module-network-linux-web-db.private_subnet_id_1, module.module-network-linux-web-db.private_subnet_id_2]
  vpc_security_group_ids      = [module.module-network-linux-web-db.security_group_db_id]
  rds-master                  = var.rds-master
  rds-replica                 = var.rds-replica
  db-name                     = var.db-name
  secret_password_id          = var.secret_password_id
  create_replica              = var.create_replica
  security_group_db           = var.security_group_db
  create_prefix_for_resources = var.create_prefix_for_resources
  depends_on = [
    module.module-network-linux-web-db,
  ]
}

################################################################################
# Bucket S3
################################################################################

module "module-s3" {
  source                      = "./modules/module-s3"
  region                      = var.region
  bucket                      = var.bucket
  env                         = var.env
  project                     = var.project
  cors_rule                   = var.cors_rule
  create_bucket_access_user   = var.create_bucket_access_user
  create_prefix_for_resources = var.create_prefix_for_resources
}

################################################################################
# Cloudwatch
################################################################################

module "module-cloudwatch" {
  source                        = "./modules/module-cloudwatch"
  env                           = var.env
  project                       = var.project
  use_cloudwatch_for_logging    = var.use_cloudwatch_for_logging
  cloudwatch_log_group          = var.cloudwatch_log_group
  create_prefix_for_resources   = var.create_prefix_for_resources
  use_cloudwatch_for_monitoring = var.use_cloudwatch_for_monitoring
  ec2_instance_id               = module.module-ec2-linux-web.server_id
  notification_email_list       = var.notification_email_list
}

################################################################################
# Amazon SES
################################################################################

resource "aws_ses_email_identity" "example" {
  count = var.enable_aws_ses ? 1 : 0
  email = var.aws_ses_email_sender
}

################################################################################
# ECR
################################################################################

module "module-ecr" {
  source                 = "./modules/module-ecr"
  region                 = var.region
  env                    = var.env
  project                = var.project
  ecr_repositories       = var.ecr_repositories
  create_ecr_access_user = var.create_ecr_access_user
}

locals {
  prefix = "${var.project}_${var.env}"
}
