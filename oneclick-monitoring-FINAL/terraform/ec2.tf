############################################
# Bastion Host
############################################
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = var.key_name

  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    set -e
    mkdir -p /home/ubuntu/.ssh
    echo "${file("${path.module}/prometheus-key.pub")}" >> /home/ubuntu/.ssh/authorized_keys
    chmod 600 /home/ubuntu/.ssh/authorized_keys
    chown -R ubuntu:ubuntu /home/ubuntu/.ssh
  EOF

  tags = {
    Name = "bastion"
  }
}

############################################
# Monitoring EC2
############################################
resource "aws_instance" "monitoring" {
  count         = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type_monitoring
  subnet_id     = element([aws_subnet.private_a.id, aws_subnet.private_b.id], count.index)

  key_name                 = var.key_name
  vpc_security_group_ids   = [aws_security_group.private_ec2_sg.id]
  iam_instance_profile     = data.aws_iam_instance_profile.prometheus_profile.name

  user_data = <<-EOF
    #!/bin/bash
    set -e
    mkdir -p /home/ubuntu/.ssh
    echo "${file("${path.module}/prometheus-key.pub")}" >> /home/ubuntu/.ssh/authorized_keys
    chmod 600 /home/ubuntu/.ssh/authorized_keys
    chown -R ubuntu:ubuntu /home/ubuntu/.ssh
  EOF

  tags = {
    Name = "monitoring-${count.index + 1}"
  }
}
