terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}
// To Generate Private Key
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
variable "key_name" {
  
}

// Create Key Pair for Connecting EC2 via SSH
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

// Save PEM file locally
resource "local_file" "private_key" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = var.key_name
}

# Create a security group

resource "aws_instance" "public_instance" {
  ami                    = "ami-05b4ded3ceb71e470"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key_pair.key_name
  // vpc_security_group_ids = [aws_security_group.sg_ec2.id]

  tags = {
    Name = "public_instance"
  }

  //root_block_device {
     //volume_size = 30
    //volume_type = "gp2"
 // }
}
