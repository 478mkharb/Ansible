############################################
# Bastion Security Group
############################################

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH from Jenkins subnet"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "SSH from Jenkins subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    # 👇 CHANGE THIS TO YOUR JENKINS PRIVATE CIDR
    cidr_blocks = ["172.31.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "bastion-sg"
    Project = var.project
  }
}

############################################
# Private EC2 Security Group
############################################

resource "aws_security_group" "private_ec2_sg" {
  name        = "private-ec2-sg"
  description = "Allow SSH only from Bastion"
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "private-ec2-sg"
    Project = var.project
  }
}
