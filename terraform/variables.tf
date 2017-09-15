variable "key_name" {
  description = "key for aws machines to connect to"
  default = "jrichardson@jmstudios.net"
}
variable "public_key_path" {
  description = "path to joseph.pub"
  default = "~/.ssh/latest_jrich_key.pub"
} 

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}


variable "aws_amis" {
  default = {
    us-west-2 = "ami-d732f0b7"
  }
}
