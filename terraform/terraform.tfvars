# Project
project_name = "clixx-prod"
environment  = "production"

# Docker Image
docker_image = "529206289534.dkr.ecr.us-east-1.amazonaws.com/clixx-app:latest"

# Database Configuration
db_name     = "clixxdb"
db_username = "admin"
db_password = "W3lcome123"

# RDS Snapshot (if restoring from snapshot)
rds_snapshot_id = "clixx-db-final-snapshot"

# ECS Service
ecs_service_desired_count = 2
