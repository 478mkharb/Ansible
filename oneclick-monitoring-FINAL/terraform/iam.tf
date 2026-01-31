# Fetch existing IAM role
data "aws_iam_role" "prometheus_role" {
  name = "prometheus-ec2-discovery"
}

# Fetch existing IAM instance profile
data "aws_iam_instance_profile" "prometheus_profile" {
  name = "prometheus-ec2-profile"
}
