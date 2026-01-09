resource "aws_db_subnet_group" "main" {
  provider = aws.dev

  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = [aws_subnet.private_mysql_1.id, aws_subnet.private_mysql_2.id]

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  provider = aws.dev

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
