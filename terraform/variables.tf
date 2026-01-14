variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "clixx-prod"
}

variable "environment" {
  type    = string
  default = "production"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "private_app_subnet_1_cidr" {
  type    = string
  default = "10.0.11.0/24"
}

variable "private_app_subnet_2_cidr" {
  type    = string
  default = "10.0.12.0/24"
}

variable "private_mysql_subnet_1_cidr" {
  type    = string
  default = "10.0.21.0/24"
}

variable "private_mysql_subnet_2_cidr" {
  type    = string
  default = "10.0.22.0/24"
}

variable "private_oracle_subnet_1_cidr" {
  type    = string
  default = "10.0.31.0/24"
}

variable "private_oracle_subnet_2_cidr" {
  type    = string
  default = "10.0.32.0/24"
}

variable "private_java_db_subnet_1_cidr" {
  type    = string
  default = "10.0.41.0/24"
}

variable "private_java_db_subnet_2_cidr" {
  type    = string
  default = "10.0.42.0/24"
}

variable "private_java_app_subnet_1_cidr" {
  type    = string
  default = "10.0.51.0/24"
}

variable "private_java_app_subnet_2_cidr" {
  type    = string
  default = "10.0.52.0/24"
}

variable "ecs_ami_name" {
  type    = string
  default = "clixx-ecs-ami-*"
}

variable "ecs_instance_type" {
  type    = string
  default = "t3.small"
}

variable "ecs_desired_capacity" {
  type    = number
  default = 2
}

variable "ecs_max_size" {
  type    = number
  default = 4
}

variable "ecs_min_size" {
  type    = number
  default = 1
}

variable "docker_image" {
  type    = string
  default = "451873237827.dkr.ecr.us-east-1.amazonaws.com/clixx-app:latest"
}

variable "rds_snapshot_id" {
  type    = string
  default = "clixx-db-final-snapshot"
}

variable "db_name" {
  type    = string
  default = "wordpressdb"
}

variable "db_username" {
  type    = string
  default = "wordpressuser"
}

variable "domain_name" {
  type    = string
  default = "ecs.clixx.enoch-stack.com"
}

variable "hosted_zone_id" {
  type    = string
  default = ""
  description = "Route53 Hosted Zone ID - leave empty to skip DNS"
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "ecs_service_desired_count" {
  description = "Desired number of ECS service tasks"
  type        = number
  default     = 2
}

variable "ecr_repository_url" {
  type        = string
  description = "ECR repository URL for Docker image"
  default     = "451873237827.dkr.ecr.us-east-1.amazonaws.com/clixx-app"
}
