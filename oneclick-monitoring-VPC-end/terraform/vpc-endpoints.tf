resource "aws_security_group" "ssm_endpoint_sg" {
  name        = "ssm-endpoint-sg"
  description = "Allow private EC2 instances to connect to SSM via VPC endpoints"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.private_ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "ssm-endpoint-sg"
    Project = var.project
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.ssm_endpoint_sg.id]
  private_dns_enabled = true

  tags = {
    Name    = "ssm-endpoint"
    Project = var.project
  }
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.ssm_endpoint_sg.id]
  private_dns_enabled = true

  tags = {
    Name    = "ec2messages-endpoint"
    Project = var.project
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.ssm_endpoint_sg.id]
  private_dns_enabled = true

  tags = {
    Name    = "ssmmessages-endpoint"
    Project = var.project
  }
}
