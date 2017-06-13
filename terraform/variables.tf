variable "key_name" {
  description = "key for aws machines to connect to"
  default = "jrichardson@jmstudios.net"
}
variable "public_key_path" {
  description = "path to joseph.pub"
  default = "~/.ssh/latest_joseph_key.pub"
} 

variable "backend_repo_url" {
  default = "get::https://github.com/Distribute-Inc/backend_api"
}
variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}


variable "aws_amis" {
  default = {
    # 16.04
    us-west-2 = "ami-d732f0b7"
 #   us-west-2 = "ami-efd0428f",
  #  us-east-1 = "ami-80861296"
  }
}
variable "bluegreen_names" {
  default = {
    "0" = "blue"
    "1" = "green"
  }
}
variable "load_instance_type" {
  default = "t2.large"
}

variable "bg_instance_type" {
  default = "t2.large"
}
