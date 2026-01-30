############################################
# Data source: Latest Ubuntu 22.04 AMI
############################################

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical (official Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

############################################
# Monitoring EC2 instances
# Prometheus + Grafana (HA - 2 instances)
############################################

resource "aws_instance" "monitoring" {
  count         = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type_monitoring

  # Distribute across private subnets
  subnet_id = element(
    [aws_subnet.private_a.id, aws_subnet.private_b.id],
    count.index
  )

  key_name = var.key_name

  iam_instance_profile   = aws_iam_instance_profile.prometheus_profile.name
  vpc_security_group_ids = [aws_security_group.monitoring_sg.id]

  tags = {
    Name    = "monitoring-${count.index + 1}"
    Role    = "monitoring"
    Project = var.project
  }
}

############################################
# Application EC2 instance
############################################

resource "aws_instance" "app" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type_app
  subnet_id     = aws_subnet.private_b.id

  key_name = var.key_name

  iam_instance_profile   = aws_iam_instance_profile.prometheus_profile.name
  vpc_security_group_ids = [aws_security_group.monitoring_sg.id]

  tags = {
    Name    = "app-1"
    Role    = "app"
    Project = var.project
  }
}
