terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "ami_name_filter" {
  type    = string
  default = "clixx-ecs-ami-*"
}

variable "instance_type" {
  type    = string
  default = "t2.small"
}

data "aws_ami" "clixx_ecs_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = [var.ami_name_filter]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "ecs_test_sg" {
  name        = "clixx-ecs-test-sg"
  description = "ECS AMI test security group"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "clixx-ecs-test-sg"
  }
}

resource "aws_iam_role" "ecs_test_role" {
  name = "clixx-ecs-test-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_test_policy" {
  role       = aws_iam_role.ecs_test_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ecs_test_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ecs_test_profile" {
  name = "clixx-ecs-test-profile"
  role = aws_iam_role.ecs_test_role.name
}

resource "aws_instance" "ecs_test" {
  ami                    = data.aws_ami.clixx_ecs_ami.id
  instance_type          = var.instance_type
  subnet_id              = tolist(data.aws_subnets.default.ids)[0]
  vpc_security_group_ids = [aws_security_group.ecs_test_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ecs_test_profile.name
  monitoring             = true

  user_data = <<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=clixx-ecs-test >> /etc/ecs/ecs.config
              echo ECS_INSTANCE_ATTRIBUTES='{"test":"ami-validation"}' >> /etc/ecs/ecs.config
              systemctl restart ecs
              EOF

  tags = {
    Name = "clixx-ecs-ami-test"
  }
}

output "instance_id" {
  value = aws_instance.ecs_test.id
}

output "instance_public_ip" {
  value = aws_instance.ecs_test.public_ip
}

output "ami_id" {
  value = data.aws_ami.clixx_ecs_ami.id
}

output "ami_name" {
  value = data.aws_ami.clixx_ecs_ami.name
}
