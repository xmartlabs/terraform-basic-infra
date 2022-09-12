terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9.0"
    }
  }
}

provider "aws" {
  region = var.region
}


resource "aws_s3_bucket" "bucket" {
  bucket = var.create_prefix_for_resources ? "${local.prefix}-${var.bucket[0].bucket}" : "${var.bucket[0].bucket}"

  tags = {
    Name        = "${local.prefix}-${var.bucket[0].bucket}"
    Project     = var.project
    Environment = var.env
  }
}

resource "aws_s3_bucket_cors_configuration" "bucket_cors" {
  bucket = aws_s3_bucket.bucket.bucket

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = var.cors_rule[0].allowed_methods
    allowed_origins = var.cors_rule[0].allowed_origins
    expose_headers  = []
    max_age_seconds = var.cors_rule[0].max_age_seconds
  }

}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

locals {
  prefix = "${var.project}-${var.env}"
}

################################################################################
# Create S3 bucket user
################################################################################
resource "aws_iam_user" "s3_user" {
  count = var.create_bucket_access_user ? 1 : 0
  name  = "${aws_s3_bucket.bucket.bucket}-s3-user"
}

resource "aws_iam_access_key" "s3_user_access_key" {
  count = var.create_bucket_access_user ? 1 : 0
  user  = aws_iam_user.s3_user[0].name
}

resource "aws_iam_user_policy" "s3_user_policy" {
  count = var.create_bucket_access_user ? 1 : 0
  name  = "${aws_s3_bucket.bucket.bucket}-s3-user-policy"
  user  = aws_iam_user.s3_user[0].name

  policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action":[
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:GetObject",
        "s3:GetObjectAcl",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.bucket.bucket}",
        "arn:aws:s3:::${aws_s3_bucket.bucket.bucket}/*"
      ]
    }
  ]
}
EOF
}
