
resource "aws_security_group" "airflow-metadata-security-group" {
  name        = "airflow-metadata-security-group-terra"
  description = "airflow postgres metadata db"
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }
  vpc_id = aws_vpc.airflow-tera-vpc.id
  tags = {
    Name = "airflow-metadata-security-group-terra"
  }
}

resource "aws_db_subnet_group" "metadata_db_subnet_group" {
  subnet_ids = [for s in data.aws_subnet.all_vps_subnet : s.id]
  tags = {
    Name = "metadata_db_subnet_group-tf"
  }
}

resource "aws_db_instance" "metadata_db" {
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = 13.7
  instance_class         = "db.t3.micro"
  db_name                = "airflow_tf"
  username               = "airflow" # ToDo username password change wirh secrate manger
  password               = "airflowpassword"
  parameter_group_name   = aws_db_parameter_group.metadata_db_extra_parameter.name
  identifier             = "metadata-db-tf"
  skip_final_snapshot    = true
  port                   = 5432
  db_subnet_group_name   = aws_db_subnet_group.metadata_db_subnet_group.name
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.airflow-metadata-security-group.id]
  tags = {
    Name = "metadata_db_tf"
  }

}


resource "aws_db_parameter_group" "metadata_db_extra_parameter" {
  name   = "metadata-db-extra-parameter"
  family = "postgres13"
  parameter {
    apply_method = "pending-reboot"
    name  = "max_connections"
    value = 100
  }
}
