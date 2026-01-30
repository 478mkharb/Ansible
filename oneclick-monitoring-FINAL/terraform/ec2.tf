resource "aws_instance" "monitoring" {
  count         = 2
  ami           = var.ubuntu_ami
  instance_type = var.instance_type_monitoring
  subnet_id     = aws_subnet.private_a.id
  key_name      = var.key_name

  iam_instance_profile = aws_iam_instance_profile.this.name
  vpc_security_group_ids = [aws_security_group.monitoring_sg.id]

  tags = {
    Name    = "monitoring-${count.index}"
    Role    = "monitoring"
    Project = var.project
  }
}

resource "aws_instance" "app" {
  ami           = var.ubuntu_ami
  instance_type = var.instance_type_app
  subnet_id     = aws_subnet.private_b.id
  key_name      = var.key_name

  iam_instance_profile = aws_iam_instance_profile.this.name
  vpc_security_group_ids = [aws_security_group.monitoring_sg.id]

  tags = {
    Name    = "app-1"
    Role    = "app"
    Project = var.project
  }
}
