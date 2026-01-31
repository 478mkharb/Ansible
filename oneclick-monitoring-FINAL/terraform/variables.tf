############################################
# AWS Region
############################################
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

############################################
# Project Name
############################################
variable "project" {
  description = "Project name for tagging"
  type        = string
}

############################################
# SSH Key Pair Name (USED BY ALL EC2s)
############################################
variable "key_name" {
  description = "EC2 key pair name (must already exist in AWS)"
  type        = string
}

############################################
# Instance Types
############################################
variable "instance_type_monitoring" {
  description = "Instance type for monitoring servers"
  type        = string
}

variable "instance_type_app" {
  description = "Instance type for application server"
  type        = string
}
