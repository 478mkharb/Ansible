############################################
# Jenkins Security Group
############################################
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Security group for Jenkins server"
  vpc_id      = aws_vpc.this.id

  # Jenkins usually does NOT need inbound SSH from the world
  # Add inbound rules here ONLY if you manually SSH into Jenkins

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "jenkins-sg"
    Project = var.project
  }
}

############################################
# Bastion Security Group
############################################
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH only from Jenkins SG"
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "SSH from Jenkins"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.jenkins_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
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
# Private EC2 Security Group (Monitoring + App)
############################################
resource "aws_security_group" "private_ec2_sg" {
  name        = "private-ec2-sg"
  description = "Allow SSH only from Bastion SG"
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
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
