terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Primary provider for Dev account
provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn     = "arn:aws:iam::529206289534:role/Engineer"
    session_name = "terraform-clixx-ecs"
  }
}

# Second provider for Management account (Route53)
provider "aws" {
  alias  = "management"
  region = var.aws_region
  assume_role {
    role_arn     = "arn:aws:iam::978820380225:role/stack_jenkins_aut"
    session_name = "terraform-route53"
  }
}
