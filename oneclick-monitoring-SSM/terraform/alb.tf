############################################
# ALB Security Group
############################################
resource "aws_security_group" "alb_sg" {
  name        = "monitoring-alb-sg"
  description = "Allow HTTP to ALB"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "monitoring-alb-sg"
    Project = var.project
  }
}

############################################
# Application Load Balancer
############################################
resource "aws_lb" "monitoring_alb" {
  name               = "monitoring-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]

  subnets = [
    aws_subnet.public.id,
    aws_subnet.public_b.id
  ]

  tags = {
    Name    = "monitoring-alb"
    Project = var.project
  }
}

############################################
# Target Group - Grafana
############################################
resource "aws_lb_target_group" "grafana_tg" {
  name        = "grafana-tg"
  port        = 30000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.this.id
  target_type = "instance"

  health_check {
    path    = "/"
    matcher = "200-399"
  }

  tags = {
    Name    = "grafana-tg"
    Project = var.project
  }
}

############################################
# Target Group - Prometheus
############################################
resource "aws_lb_target_group" "prometheus_tg" {
  name        = "prometheus-tg"
  port        = 30090
  protocol    = "HTTP"
  vpc_id      = aws_vpc.this.id
  target_type = "instance"

  health_check {
    path    = "/"
    matcher = "200-399"
  }

  tags = {
    Name    = "prometheus-tg"
    Project = var.project
  }
}

############################################
# ALB Listener
############################################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.monitoring_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Monitoring ALB Running"
      status_code  = "200"
    }
  }
}

############################################
# Listener Rule - Grafana
############################################
resource "aws_lb_listener_rule" "grafana_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  condition {
    path_pattern {
      values = ["/grafana*", "/"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana_tg.arn
  }
}

############################################
# Listener Rule - Prometheus
############################################
resource "aws_lb_listener_rule" "prometheus_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 20

  condition {
    path_pattern {
      values = ["/prometheus*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prometheus_tg.arn
  }
}
