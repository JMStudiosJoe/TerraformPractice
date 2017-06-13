provider "aws" {
  region     = "us-west-2"
}
resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "CeleryServer" {
  ami           = "ami-d732f0b7"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.auth.id}"	
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install python-minimal",
    ]
  }
}
resource "aws_instance" "BackendServer" {
  ami           = "ami-d732f0b7"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.auth.id}"
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install python-minimal",
    ]
  }
}
resource "aws_security_group" "default" {
  name        = "terraform_example"
  description = "Used in the terraform"

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



resource "aws_instance" "load" {
  tags {
    Name = "switch"
  }

  connection {
    user = "ubuntu"
  }
  # instance_type = "t2.micro"
  instance_type = "${var.load_instance_type}"
  ami = "ami-d732f0b7"
  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.load.id}"]
  subnet_id = "${aws_subnet.default.id}"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install python-minimal",
    ]
  }

}

resource "aws_instance" "ansible-ctrl" {
  tags {
    Name = "ansible-ctrl"
  }

  connection {
    user = "ubuntu"
  }
  instance_type = "t2.small"
  ami = "ami-d732f0b7"
  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.ansible-control.id}"]
  subnet_id = "${aws_subnet.default.id}"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install ansible",
    ]
  }
}
