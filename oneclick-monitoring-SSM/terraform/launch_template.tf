resource "aws_launch_template" "monitoring_lt" {
  name_prefix   = "monitoring-lt-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type_monitoring

  iam_instance_profile {
    name = "ec2-ssm-profile"
  }

  vpc_security_group_ids = [
    aws_security_group.private_ec2_sg.id
  ]

  user_data = base64encode(<<EOF
#!/bin/bash
set -eux

# Install SSM Agent (Ubuntu via snap)
if ! systemctl is-active --quiet snap.amazon-ssm-agent.amazon-ssm-agent; then
  snap install amazon-ssm-agent --classic || true
fi

systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent
systemctl restart snap.amazon-ssm-agent.amazon-ssm-agent

# Debug proof
echo "SSM agent installed and started" > /var/log/ssm-bootstrap.log
EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "monitoring-instance"
      Role    = var.role
      Project = var.project
    }
  }
}
