terraform {
  required_version = ">= 0.14.9"
}

provider "aws" {
  region  = var.region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "${var.name}_vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/25"
  availability_zone = var.availability_zone

  tags = {
    Name = "${var.name}_subnet-public"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}_igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name}_rt-public"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "allow-ssh-and-customport" {
  name        = "allow-ssh-and-customport"
  description = "security group of ${var.name}"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
  }
  ingress {
    description      = "Allow Custom Port"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}_allow-ssh-and-customport"
  }
}

resource "aws_key_pair" "key" {
  key_name   = "${var.name}_key"
  public_key = var.public_key
}

resource "aws_instance" "ec2-tunnel" {
  ami               = "ami-0dc5785603ad4ff54"
  instance_type     = "t2.micro"
  availability_zone = var.availability_zone
  get_password_data = false
  key_name          = aws_key_pair.key.key_name

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.allow-ssh-and-customport.id]
  subnet_id              = aws_subnet.public.id

  tags = {
    Name = "${var.name}_ec2"
  }
}

output "ec2_global_ip" {
  value = aws_instance.ec2-tunnel.public_ip
}
