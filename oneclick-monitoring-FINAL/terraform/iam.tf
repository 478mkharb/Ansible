# Fetch existing IAM role
data "aws_iam_role" "prometheus_role" {
  name = "prometheus-ec2-discovery"
}

# Create instance profile using existing role
resource "aws_iam_instance_profile" "prometheus_profile" {
  name = "prometheus-ec2-profile"
  role = data.aws_iam_role.prometheus_role.name
}
