# Project
project_name = "clixx-prod"
environment  = "production"

# Docker Image  
docker_image = "451873237827.dkr.ecr.us-east-1.amazonaws.com/clixx-app:latest"

# Database Configuration
db_name     = "wordpressdb"
db_username = "wordpressuser"
db_password = "W3lcome123"

# RDS Snapshot
rds_snapshot_id = "clixx-db-final-snapshot"

# Domain Configuration
hosted_zone_id = "Z09754283M1E3YFVQVDL2"
domain_name    = "ecs.enoch-stack.com"

# ECS Service
ecs_service_desired_count = 2
