terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9.0"
    }
  }
}

################################################################################
# RDS -subnetgrup
################################################################################

resource "aws_db_subnet_group" "subnetgrup" {
  name       = var.subnet_group
  subnet_ids = var.subnet_ids

  tags = {
      Name        = var.create_prefix_for_resources ? "${var.project}_${var.env}_${var.subnet_group}" : "${var.subnet_group}"
      Project     = var.project
      Environment = var.env
  }
}

################################################################################
# Master DB
################################################################################

module "master" {
    source  = "terraform-aws-modules/rds/aws"
    version = "4.4.0"
    #The name of the RDS instance
    identifier = var.create_prefix_for_resources ? "${var.project}-${var.env}-${var.rds-master[0].Name}" : "${var.rds-master[0].Name}"

    tags = {
      Name        = var.create_prefix_for_resources ? "${var.project}-${var.env}-${var.rds-master[0].Name}" : "${var.rds-master[0].Name}"
      Project     = var.project
      Environment = var.env
    }

    #The database engine to use
    engine            = var.rds-master[0].engine
    engine_version    = var.rds-master[0].engine_version
    instance_class    = var.rds-master[0].instance_class
    allocated_storage = var.rds-master[0].allocated_storage
    storage_encrypted = false

    db_name  = var.db-name
    username = jsondecode(data.aws_secretsmanager_secret_version.secret_password_rds.secret_string)["username"]
    password = jsondecode(data.aws_secretsmanager_secret_version.secret_password_rds.secret_string)["password"]
    port     = var.security_group_db[0].dbport

    iam_database_authentication_enabled = true
    create_random_password              = false

    # DB parameter group
    family = var.rds-master[0].family


    create_db_subnet_group = false
    vpc_security_group_ids = var.vpc_security_group_ids
    db_subnet_group_name   = aws_db_subnet_group.subnetgrup.id


    #multi_az = true
    deletion_protection = false


    #To disable collecting Enhanced Monitoring metrics, specify 0.
    monitoring_interval = "0"
    #Create IAM role with a defined name that permits RDS to send enhanced monitoring metrics to CloudWatch Logs.
    create_monitoring_role = false

    # Backups are required in order to create a replica
    backup_retention_period = 1
    skip_final_snapshot     = true
    maintenance_window      = "Tue:00:00-Tue:03:00"
    backup_window           = "03:00-06:00"
}


################################################################################
# Replica DB
################################################################################

module "replica" {
    source = "terraform-aws-modules/rds/aws"
    version = "4.4.0"

    create_db_instance = var.create_replica
    identifier         = var.create_prefix_for_resources ? "${var.project}-${var.env}-${var.rds-replica[0].Name}" : "${var.rds-replica[0].Name}"

    tags = {
      Name        = var.create_prefix_for_resources ? "${var.project}-${var.env}-${var.rds-replica[0].Name}" : "${var.rds-replica[0].Name}"
      Project     = var.project
      Environment = var.env
    }

    # Source database. For cross-region use db_instance_arn
    replicate_source_db    = module.master.db_instance_id
    create_random_password = false

    engine            = var.rds-master[0].engine
    engine_version    = var.rds-master[0].engine_version
    instance_class    = var.rds-master[0].instance_class
    allocated_storage = var.rds-master[0].allocated_storage
    storage_encrypted = false

    # Username and password should not be set for replicas
    username               = null
    password               = null
    port                   = var.security_group_db[0].dbport
    multi_az               = false
    vpc_security_group_ids = var.vpc_security_group_ids

    # DB parameter group
    family = var.rds-master[0].family

    backup_retention_period = 0
    skip_final_snapshot     = true
    deletion_protection     = false

    # Not allowed to specify a subnet group for replicas in the same region
    create_db_subnet_group = false
    maintenance_window     = "Tue:00:00-Tue:03:00"
    backup_window          = "03:00-06:00"

    depends_on = [
      module.master,
    ]
}
