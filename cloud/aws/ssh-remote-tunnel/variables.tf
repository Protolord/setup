variable "name" {
  default     = "ssh-remote-tunnel"
  description = "Prefix of AWS resources"
}

variable "region" {
  default     = "ap-southeast-1"
  description = "AWS Region"
}

variable "availability_zone" {
  default     = "ap-southeast-1a"
  description = "Availability Zone"
}

variable "my_ip" {
  default     = "0.0.0.0/0"
  description = "My IP address"
}

variable "public_key" {
  default     = ""
  description = "OpenSSH public key"
}
