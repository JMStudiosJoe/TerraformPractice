variable "key_name" {
  description = "key for aws machines to connect to"
  default = "joseph"
}
variable "public_key_path" {
  description = "path to joseph.pub"
  default = "~/.ssh/latest_joseph_key.pub"
} 

variable "backend_repo_url" {
  default = "get::https://github.com/Distribute-Inc/backend_api"
}
