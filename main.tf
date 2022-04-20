terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9.0"
    }
  }

  required_version = ">= 1.0.6"
}

# Setup AWS provider
provider "aws" {
  region     = "ap-southeast-1"
  access_key = "AKIATUR7ZDHQ2T4VFGUA"
  secret_key = "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"
}

data "aws_vpc" "vpc1" {
  filter {
    name   = "tag:Name"
    values = ["VPC-1"]
  }
}
output "vpc-test" {
  value = data.aws_vpc.vpc1
}


resource "aws_instance" "app" {
  ami                    = "ami-0971b4b88a87adeef"
  instance_type          = "t2.micro"
  key_name               = "Access-EC2"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    "Name" = "Instance1"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.vpc1.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}
