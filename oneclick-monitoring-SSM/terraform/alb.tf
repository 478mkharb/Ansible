############################################
# Application Load Balancer
############################################

resource "aws_lb" "monitoring_alb" {
  name               = "monitoring-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  tags = {
    Name    = "monitoring-alb"
    Project = var.project
  }
}

############################################
# Target Group - Grafana (NodePort 32000)
############################################

resource "aws_lb_target_group" "grafana_tg" {
  name        = "grafana-tg"
  port        = 32000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.this.id
  target_type = "instance"

  health_check {
    path                = "/login"
    port                = "32000"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 15
    timeout             = 5
    matcher             = "200-399"
  }

  tags = {
    Name    = "grafana-tg"
    Project = var.project
  }
}

############################################
# Target Group - Prometheus (NodePort 32090)
############################################

resource "aws_lb_target_group" "prometheus_tg" {
  name        = "prometheus-tg"
  port        = 32090
  protocol    = "HTTP"
  vpc_id      = aws_vpc.this.id
  target_type = "instance"

  health_check {
    path                = "/-/ready"
    port                = "32090"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 15
    timeout             = 5
    matcher             = "200-399"
  }

  tags = {
    Name    = "prometheus-tg"
    Project = var.project
  }
}

############################################
# Listener - Grafana (HTTP :80)
############################################

resource "aws_lb_listener" "grafana_http" {
  load_balancer_arn = aws_lb.monitoring_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana_tg.arn
  }
}

############################################
# Listener - Prometheus (HTTP :9090)
############################################

resource "aws_lb_listener" "prometheus_http" {
  load_balancer_arn = aws_lb.monitoring_alb.arn
  port              = 9090
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prometheus_tg.arn
  }
}

resource "aws_autoscaling_attachment" "grafana_asg_attach" {
  autoscaling_group_name = aws_autoscaling_group.monitoring_asg.name
  lb_target_group_arn    = aws_lb_target_group.grafana_tg.arn
}

resource "aws_autoscaling_attachment" "prometheus_asg_attach" {
  autoscaling_group_name = aws_autoscaling_group.monitoring_asg.name
  lb_target_group_arn    = aws_lb_target_group.prometheus_tg.arn
}
