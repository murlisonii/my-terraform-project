provider "aws" {
  region = "us-east-1" 
}

resource "aws_security_group" "http" {
  name_prefix = "http-sg"

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

  count = 2 

  availability_zone = element(data.aws_availability_zones.available.names, count.index) 
  # No need to change unless you want specific AZs.

  security_groups = [aws_security_group.http.name]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "Hello from instance $(hostname)" > /var/www/html/index.html
  EOF
}

data "aws_availability_zones" "available" {}

output "public_ips" {
  value = aws_instance.web.*.public_ip
}
