/*
# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16" # Replace with your desired CIDR block for the VPC

  tags = {
    Name = "my-vpc"
  }
}

# Create a public subnet within the VPC
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24" # Replace with your desired CIDR block for the subnet
  availability_zone = "us-east-1a" # Replace with your desired availability zone

  tags = {
    Name = "public-subnet"
  }
}

# Create a security group for the EC2 instance
resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.my_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance-sg"
  }
}

# Create an EC2 instance within the public subnet
resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-0d94353f7bad10668 " # Replace with your desired AMI ID
  instance_type = "t2.micro" # Replace with your desired instance type
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.instance_sg.id]

  tags = {
    Name = "my-ec2-instance"
  }
}
*/