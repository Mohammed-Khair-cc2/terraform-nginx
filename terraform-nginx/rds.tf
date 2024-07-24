# RDS subnet grp
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.public_subnet_2.id, aws_subnet.public_subnet_3.id]
}

# RDS security grp
resource "aws_security_group" "rds-sg" {
  name   = "my-db-sg"
  vpc_id = aws_vpc.main.id

  # ingress {
  #   from_port       = 3306 # MySQl port
  #   to_port         = 3306
  #   protocol        = "tcp"
  #   security_groups = [aws_security_group.EC2-sg.id]
  # }
}

# RDS instance
resource "aws_db_instance" "my_db_instance" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name              = "dbdatabase"
  username             = "admin"
  password             = "password"
  parameter_group_name = "default.mysql5.7"
  # skip_final_snapshot is required to destroy db using terraform
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

  # Attach the DB security group
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  tags = {
    Name = "ec2_to_mysql_rds"
  }
}

# Security Rule EC2 instance to connect RDS
resource "aws_security_group_rule" "ec2_to_db" {
  type                     = "ingress"
  from_port                = 3306 # MySQL port
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds-sg.id # RDS security group
  source_security_group_id = aws_security_group.EC2-sg.id # EC2 security group
}
