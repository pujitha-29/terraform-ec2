// Create a VPC
resource "aws_vpc" "avivavpc" {
  cidr_block = "10.0.0.0/16"
}

// Create a subnet within the VPC
resource "aws_subnet" "avivasubnet" {
  vpc_id            = aws_vpc.avivavpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a" 
}

// Create a security group to allow traffic
resource "aws_security_group" "avivasg" {
  vpc_id = aws_vpc.avivavpc.id

  // Allow inbound traffic on port 80 (HTTP) and 22 (SSH) for EC2
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Launch an EC2 instance within the subnet
resource "aws_instance" "aviva_ec2_instance" {
  ami                    = "ami-0ac67a26390dc374d"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.avivasubnet.id
  security_groups        = [aws_security_group.avivasg.name]

  tags = {
    Name = "aviva.instance"
  }
}

// Create a load balancer
resource "aws_lb" "aviva_load_balancer" {
  name               = "aviva-load-balancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.avivasubnet.id]

  tags = {
    Name = "aviva-load-balancer"
  }
}

// Attach the EC2 instance to the load balancer
resource "aws_lb_target_group_attachment" "my_attachment" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.aviva.instance.id
}

// Create a listener for the load balancer
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.avivalb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.avivatg.arn
    type             = "forward"
  }
}

// Create a target group for the load balancer
resource "aws_lb_target_group" "avivatg" {
  name        = "avivatg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.avivavpc.id

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
}
