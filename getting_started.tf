provider "aws" {
  region     = "us-west-2"
}

resource "aws_instance" "BlueJoeEC2" {
  ami           = "ami-d732f0b7"
  instance_type = "t2.micro"
}
resource "aws_eip" "ip" {
  instance = "${aws_instance.BlueJoeEC2.id}"
}
