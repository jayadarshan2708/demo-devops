provider "aws" {
	region = var.region
}

resource "aws_key_pair" "jenkins_key" {
	key_name = var.key_name
	public_key= file(var.public_key_path)
}

resource "aws_security_group" "app_sg" {
	name = "app-sg"
	description = "Allow SSH and HTTP"
	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	ingress {
		from_port = 80
		to_port =80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks =["0.0.0.0/0"]
	}
}

resource "aws_instance" "app" {
	ami = data.aws_ami.ubuntu.id
	instance_type = var.instance_type
	key_name = aws_key_pair.jenkins_key.key.pem
	
	user_data = file("provision.sh")

	tags = {
		Name = "devops-demo-app"
	}
}

data "aws_ami" "ubuntu" {
	most_recent = true
	owners = ["099720109477"]
	filter {
		name = "Server"
		values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-8-*"]
		}
}

output "public_ip" {
	value = aws_instance.app.public_ip
}

output "public_dns" {
	value = aws_instance.app.public_dns
}
