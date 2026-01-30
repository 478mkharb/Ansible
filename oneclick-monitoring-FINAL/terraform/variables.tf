variable "region" {
  default = "ap-south-1"
}

variable "project" {
  default = "oneclick-monitoring"
}

variable "ubuntu_ami" {
  description = "Ubuntu 22.04 AMI ID"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "instance_type_monitoring" {
  default = "t3.medium"
}

variable "instance_type_app" {
  default = "t3.micro"
}
