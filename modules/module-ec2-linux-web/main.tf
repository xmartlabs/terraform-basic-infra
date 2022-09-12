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

resource "aws_instance" "ec2-instance" {
  ami           = var.amiid
  instance_type = var.size

  root_block_device {
    volume_size = var.root_disk[0].volume_size
  }

  key_name  = var.key_name
  user_data = templatefile(var.create_machine_script, {})

  tags = {
    Name        = var.create_prefix_for_resources ? "${local.prefix}_${var.ec2name}" : "${var.ec2name}"
    Project     = var.project
    Environment = var.env
  }

  network_interface {
    device_index         = var.device_index_network_interface
    network_interface_id = var.id_network_interface
  }

  iam_instance_profile = var.iam_instance_profile
}

locals {
  prefix = "${var.project}_${var.env}"
}
