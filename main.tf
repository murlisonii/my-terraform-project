provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "http_sg" {
  name        = "http-sg"
  description = "Allow HTTP traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-01816d07b1128cd2d"
  instance_type = "t2.micro"
  key_name      = "murli1"
  
  security_groups = [aws_security_group.http_sg.name]
  
  availability_zone = "us-east-1a"
  
  tags = {
    Name = "WebServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF
}

resource "aws_instance" "web_2" {
  ami           = "ami-01816d07b1128cd2d"
  instance_type = "t2.micro"
  key_name      = "murli1"
  
  security_groups = [aws_security_group.http_sg.name]
  
  availability_zone = "us-east-1b"
  
  tags = {
    Name = "WebServer2"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF
}
