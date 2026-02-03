resource "aws_instance" "monitoring" {
  count         = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type_monitoring

  subnet_id = element(
    [aws_subnet.private_a.id, aws_subnet.private_b.id],
    count.index
  )

  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name
  vpc_security_group_ids = [aws_security_group.private_ec2_sg.id]

  tags = {
    Name    = "monitoring-${count.index + 1}"
    Role    = var.role
    Project = var.project
  }
}
