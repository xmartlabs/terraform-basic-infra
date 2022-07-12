################################################################################
# Cloudwatch
################################################################################

resource "aws_cloudwatch_log_group" "log-group" {
  count             = var.use_cloudwatch_for_logging ? 1 : 0
  name              = var.create_prefix_for_resources ? "${local.prefix}_${var.cloudwatch_log_group}" : "${var.cloudwatch_log_group}" 
  retention_in_days = 30
}

resource "aws_iam_role" "cloudwatch_role" {
  count              = var.use_cloudwatch_for_logging ? 1 : 0
  name               = var.create_prefix_for_resources ? "${local.prefix}_${var.cloudwatch_log_group}_role" : "${var.cloudwatch_log_group}_role" 

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "sts:AssumeRole"
        ],
        "Principal": {
            "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}

resource "aws_iam_instance_profile" "cloudwatch_profile" {
  count = var.use_cloudwatch_for_logging ? 1 : 0
  name  = var.create_prefix_for_resources ? "${local.prefix}_${var.cloudwatch_log_group}_profile" : "${var.cloudwatch_log_group}_profile"
  role  =  aws_iam_role.cloudwatch_role[0].name
}

resource "aws_iam_role_policy" "cloudwatch_policy" {
  count  = var.use_cloudwatch_for_logging ? 1 : 0
  name   = var.create_prefix_for_resources ? "${local.prefix}_${var.cloudwatch_log_group}_password-policy-parameterstore" : "${var.cloudwatch_log_group}_password-policy-parameterstore"
  role   = aws_iam_role.cloudwatch_role[0].id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:logs:*:*:*"
      }
    ]
  }
  EOF
}

locals {
  prefix = "${var.project}_${var.env}"
}
