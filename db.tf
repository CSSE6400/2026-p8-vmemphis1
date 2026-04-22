locals {
    database_username = "administrator"
    database_password = "VerySecurePassword123XYZ"
}

resource "aws_db_instance" "taskoverflow_database" {
  allocated_storage      = 20
  max_allocated_storage  = 1000
  engine                 = "postgres"
  engine_version         = "14"
  instance_class         = "db.t4g.micro"
  db_name                = "taskoverflow"
  username               = local.database_username
  password               = local.database_password
  parameter_group_name   = "default.postgres14"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.taskoverflow_database.name
  vpc_security_group_ids = [aws_security_group.taskoverflow_database.id]
  publicly_accessible    = true
  tags = {
    name = "taskoverflow_database"
  }
}

resource "aws_db_subnet_group" "taskoverflow_database" {
  name       = "taskoverflow-database-subnet-group"
  subnet_ids = data.aws_subnets.private.ids

  tags = {
    name = "taskoverflow_database_subnet_group"
  }
}

resource "aws_security_group" "taskoverflow_database" {
  name        = "taskoverflow_database"
  description = "Allow inbound Postgres traffic"

  ingress {
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    name = "taskoverflow_db_security_group"
  }
}
