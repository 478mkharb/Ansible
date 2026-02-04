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

# Log everything
exec > /var/log/user-data.log 2>&1

echo "Installing SSM Agent (DEB)"

# Update packages
apt-get update -y

# Install SSM agent via DEB (most reliable)
if ! systemctl is-active --quiet amazon-ssm-agent; then
  curl -o /tmp/amazon-ssm-agent.deb \
    https://s3.ap-south-1.amazonaws.com/amazon-ssm-ap-south-1/latest/debian_amd64/amazon-ssm-agent.deb

  dpkg -i /tmp/amazon-ssm-agent.deb || apt-get -f install -y
fi

# Enable & start agent
systemctl enable amazon-ssm-agent
systemctl restart amazon-ssm-agent

systemctl status amazon-ssm-agent --no-pager || true

echo "SSM agent installed and started successfully"
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
