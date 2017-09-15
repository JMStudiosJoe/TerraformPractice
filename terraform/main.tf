provider "aws" {
  region     = "us-west-2"
}
resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "JMStudiosServer" {
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
