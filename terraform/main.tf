
# currently not in use yet...
#data "aws_eip" "proxy_ip" {
#  public_ip = "${var.public_ip}"
#}



provider "aws" {
  region     = "us-west-2"
}
resource "aws_eip" "resource_proxy_eip" {
  instance = "${aws_instance.JMStudDOTIOServer.id}"
  vpc = true
}
resource "aws_eip_association" "proxy_eip_association" {
  instance_id   = "aws_instance.JMStudDOTIOServer.id "
  allocation_id = "${aws_eip.resource_proxy_eip.id}"
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}
resource "aws_security_group" "default" {
  name        = "jmstudios_security_group"
  description = "Used in website somehow"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#resource "aws_route53_zone" "main" {
#  name = "jmstudios.net"
#}

resource "aws_route53_zone" "main" {
  name = "jmstud.io"

  tags {
    Environment = "dev"
  }
}

resource "aws_route53_record" "dns" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "jmstud.io"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.main.name_servers.0}",
    "${aws_route53_zone.main.name_servers.1}",
    "${aws_route53_zone.main.name_servers.2}",
    "${aws_route53_zone.main.name_servers.3}",
  ]
}
resource "aws_instance" "JMStudDOTIOServer" {
  ami           = "ami-d732f0b7"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.auth.id}"
 # security_groups = ["${aws_security_group.default.name}"]
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install python-minimal",
    ]
  }
}
