provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_default_vpc" "default-vpc" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "instanceSecurityGroup" {
  name        = "instance-sg"
  description = "Allow some inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.default-vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "JenkinsServerSecurityGroup" {
  name        = "jenkins-server-sg"
  description = "Allow some inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.default-vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 8082
    to_port     = 8082
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

locals {
  instance_type = "t2.micro"
  key_pair_name = "my-project-kp"
  AZ_QA         = "ap-southeast-1a"
  AZ_Staging    = "ap-southeast-1b"
}

resource "aws_instance" "Jenkins-server-instance" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = local.instance_type
  security_groups   = [aws_security_group.JenkinsServerSecurityGroup.name]
  key_name          = local.key_pair_name

  root_block_device {
    volume_size = "12"
    volume_type = "gp2"
  }

  tags = {
    Name = "Jenkins-server"
  }
}

resource "aws_instance" "QA" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = local.instance_type
  security_groups   = [aws_security_group.instanceSecurityGroup.name]
  key_name          = local.key_pair_name
  availability_zone = local.AZ_QA

  tags = {
    Name = "QA"
  }
}

resource "aws_instance" "Staging" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = local.instance_type
  security_groups   = [aws_security_group.instanceSecurityGroup.name]
  key_name          = local.key_pair_name
  availability_zone = local.AZ_Staging

  tags = {
    Name = "Staging"
  }
}

