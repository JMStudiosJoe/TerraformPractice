provider "aws" {
  region     = "us-west-2"
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
    cidr_blocks = ["10.0.0.0/16"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "JMStudiosServer" {
  ami           = "ami-d732f0b7"
  instance_type = "t2.micro"
  #vpc_security_group_ids = ["${aws_security_group.default.id}"]
  key_name      = "${aws_key_pair.auth.id}"
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install python-minimal",
      #"sudo apt-get -y install git"
    ]
  }
}
