provider "aws" {
  region = "eu-north-1"
}

resource "aws_security_group" "web_sg" {
  name = "web_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
  ami           = "ami-0c1ac8a41498c1a9c"
  instance_type = "t3.micro"
  key_name      = "ec2kp"

  security_groups = [aws_security_group.web_sg.name]

  user_data = <<-EOT
              #!/bin/bash
              apt update -y
              apt install nginx -y
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Hello from Terraform 🚀</h1>" > /var/www/html/index.html
              EOT

  tags = {
    Name = "terraform-server"
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}
