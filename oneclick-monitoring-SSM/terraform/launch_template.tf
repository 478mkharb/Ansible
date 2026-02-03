resource "aws_launch_template" "monitoring_lt" {
  name_prefix   = "monitoring-lt-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type_monitoring

  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_profile.name
  }

  vpc_security_group_ids = [
    aws_security_group.private_ec2_sg.id
  ]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "monitoring-asg"
      Role    = var.role
      Project = var.project
    }
  }
}
