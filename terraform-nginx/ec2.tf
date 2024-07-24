# Create EC2 sg
resource "aws_security_group" "EC2-sg" {
  name        = "nginx-ec2-sg"
  description = "nginx-ec2-sg"
  vpc_id      = aws_vpc.main.id

  # allow ssh
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # allow incomming traffic from alb
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }
  # allow incoming traffic from rds
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    description     = "MySQL"
    security_groups = [aws_security_group.rds-sg.id]
  }


  # allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nginx-ec2_security_group"
  }
}


# Create ec2 instance
resource "aws_instance" "nginx-ec2" {
  instance_type               = "t2.micro"
  ami                         = var.ami
  associate_public_ip_address = true
  key_name                    = "terraform.pem"
  subnet_id                   = aws_subnet.public_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.EC2-sg.id]
  user_data                   = filebase64("scripts/install_nginx.sh")


  tags = {
    Name = "nginx-ec2-rds"
  }
}
