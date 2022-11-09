################################################################################
# Cloudwatch
################################################################################

resource "aws_cloudwatch_log_group" "log-group" {
  count             = var.use_cloudwatch_for_logging ? 1 : 0
  name              = var.create_prefix_for_resources ? "${local.prefix}_${var.cloudwatch_log_group}" : "${var.cloudwatch_log_group}"
  retention_in_days = 30
}

resource "aws_iam_role" "cloudwatch_role" {
  count = var.use_cloudwatch_for_logging || var.use_cloudwatch_for_monitoring ? 1 : 0
  name  = var.create_prefix_for_resources ? "${local.prefix}_${var.cloudwatch_log_group}_role" : "${var.cloudwatch_log_group}_role"

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
  count = var.use_cloudwatch_for_logging || var.use_cloudwatch_for_monitoring ? 1 : 0
  name  = var.create_prefix_for_resources ? "${local.prefix}_${var.cloudwatch_log_group}_profile" : "${var.cloudwatch_log_group}_profile"
  role  = aws_iam_role.cloudwatch_role[0].name
}

resource "aws_iam_role_policy" "cloudwatch_policy" {
  count = var.use_cloudwatch_for_logging ? 1 : 0
  name  = var.create_prefix_for_resources ? "${local.prefix}_${var.cloudwatch_log_group}_password-policy-parameterstore" : "${var.cloudwatch_log_group}_password-policy-parameterstore"
  role  = aws_iam_role.cloudwatch_role[0].id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
            "cloudwatch:PutMetricData",
            "ec2:DescribeVolumes",
            "ec2:DescribeTags",
            "logs:PutLogEvents",
            "logs:DescribeLogStreams",
            "logs:DescribeLogGroups",
            "logs:CreateLogStream",
            "logs:CreateLogGroup"
        ],
        "Resource": "*"
      }
    ]
  }
  EOF
}

resource "aws_cloudwatch_metric_alarm" "ec2_cpu" {
  count                     = var.use_cloudwatch_for_monitoring ? 1 : 0
  alarm_name                = var.create_prefix_for_resources ? "${local.prefix}_${var.cloudwatch_log_group}_cpu_utilization" : "cpu_utilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120" #seconds
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.topic[0].arn]
  ok_actions                = [aws_sns_topic.topic[0].arn]

  dimensions = {
    InstanceId = var.ec2_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "ec2_disk" {
  count               = var.use_cloudwatch_for_monitoring ? 1 : 0
  alarm_name          = var.create_prefix_for_resources ? "${local.prefix}_${var.cloudwatch_log_group}_disk_utilization" : "disk_utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = "120"
  statistic           = "Average"
  threshold           = "40"
  alarm_description   = "This metric monitors ec2 disk utilization"
  actions_enabled     = "true"
  alarm_actions       = [aws_sns_topic.topic[0].arn]
  ok_actions          = [aws_sns_topic.topic[0].arn]

  dimensions = {
    path       = "/"
    InstanceId = var.ec2_instance_id
    device     = "xvda1"
    fstype     = "xfs"
  }
}

resource "aws_cloudwatch_metric_alarm" "ec2_mem" {
  count               = var.use_cloudwatch_for_monitoring ? 1 : 0
  alarm_name          = var.create_prefix_for_resources ? "${local.prefix}_${var.cloudwatch_log_group}_mem_utilization" : "mem_utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = "120"
  statistic           = "Average"
  threshold           = "40"
  alarm_description   = "This metric monitors ec2 memory utilization"
  actions_enabled     = "true"
  alarm_actions       = [aws_sns_topic.topic[0].arn]
  ok_actions          = [aws_sns_topic.topic[0].arn]

  dimensions = {
    InstanceId = var.ec2_instance_id
  }
}

resource "aws_sns_topic" "topic" {
  count = var.use_cloudwatch_for_monitoring ? 1 : 0
  name  = var.create_prefix_for_resources ? "${local.prefix}_${var.cloudwatch_log_group}_cpu-utilization-topic" : "cpu-utilization-topic"
}

resource "aws_sns_topic_subscription" "topic_email_subscription" {
  count     = var.use_cloudwatch_for_monitoring ? length(var.notification_email_list) : 0
  topic_arn = aws_sns_topic.topic[0].arn
  protocol  = "email"
  endpoint  = var.notification_email_list[count.index]
}

locals {
  prefix = "${var.project}_${var.env}"
}
