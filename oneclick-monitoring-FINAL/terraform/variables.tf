variable "region" {
  default = "ap-south-1"
}

variable "project" {
  default = "oneclick-monitoring"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "instance_type_monitoring" {
  default = "t3.small"
}

variable "instance_type_app" {
  default = "t3.micro"
}
