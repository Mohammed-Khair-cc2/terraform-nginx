# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc-cidr

  tags = {
    Name = "${var.nginx-project}-vpc"
  }
}
# create public subnet 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "${var.nginx-project}-public-subnet-1"
  }
}
# create public subnet 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "${var.nginx-project}-public-subnet-2"
  }
}
# create public subnet 3
resource "aws_subnet" "public_subnet_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/20"
  availability_zone = "eu-west-1c"

  tags = {
    Name = "${var.nginx-project}-public-subnet-3"
  }
}

# create IGW

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.nginx-project}-igw"
  }
}

# create public route table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.nginx-project}-public-rt"
  }
}
resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.main.id
}
resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.main.id
}
resource "aws_route_table_association" "public_subnet_3" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.main.id
}
