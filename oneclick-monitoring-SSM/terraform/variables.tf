variable "region" {
  default = "ap-south-1"
}

variable "project" {
  default = "oneclick-monitoring"
}

variable "instance_type_monitoring" {
  default = "t3.small"
}

variable "role" {
  description = "Role tag for the instances"
  type        = string
}

variable "monitoring_instance_ids" {
  description = "List of monitoring instance IDs"
  type        = list(string)
}