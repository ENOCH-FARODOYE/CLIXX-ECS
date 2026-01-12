resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = [aws_subnet.private_mysql_1.id, aws_subnet.private_mysql_2.id]
  
  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier             = "${var.project_name}-db"
  snapshot_identifier    = var.rds_snapshot_id
  instance_class         = "db.t3.micro"
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  skip_final_snapshot    = false
  final_snapshot_identifier = "${var.project_name}-db-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  
  tags = {
    Name = "${var.project_name}-db"
  }
}

# Store RDS password in Parameter Store
resource "aws_ssm_parameter" "db_password" {
  name        = "/${var.project_name}/db/password"
  description = "RDS master password for ${var.project_name}"
  type        = "SecureString"
  value       = var.db_password
  
  tags = {
    Name = "${var.project_name}-db-password"
  }
}
