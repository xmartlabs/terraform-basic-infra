# ECR
resource "aws_ecr_repository" "ecr_repository" {
  for_each = { for record in var.ecr_repositories : record.name => record }
  name     = lower("${each.value.name}")
}

resource "aws_ecr_lifecycle_policy" "ecr_lifecycle_policy" {
  for_each   = { for record in var.ecr_repositories : record.name => record }
  repository = each.value.name
  policy     = <<-EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last N images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": ${each.value.max_images}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
  EOF
}

################################################################################
# Create ECR user
################################################################################
resource "aws_iam_user" "ecr_user" {
  count = var.create_ecr_access_user ? 1 : 0
  name  = "${local.prefix}-ecr-user"
}

resource "aws_iam_access_key" "ecr_user_access_key" {
  count = var.create_ecr_access_user ? 1 : 0
  user  = aws_iam_user.ecr_user[0].name
}

resource "aws_iam_user_policy" "ecr_user_policy" {
  count = var.create_ecr_access_user ? 1 : 0
  name  = "${local.prefix}-ecr-user-policy"
  user  = aws_iam_user.ecr_user[0].name

  policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action":[
        "ecr:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

locals {
  prefix = "${var.project}-${var.env}"
}
