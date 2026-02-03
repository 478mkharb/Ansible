resource "aws_lb" "monitoring_alb" {
  name               = "monitoring-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public.id]

  tags = {
    Project = var.project
  }
}

resource "aws_lb_target_group" "grafana_tg" {
  name        = "grafana-tg"
  port        = 30000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.this.id
  target_type = "instance"

  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group" "prometheus_tg" {
  name        = "prometheus-tg"
  port        = 30090
  protocol    = "HTTP"
  vpc_id      = aws_vpc.this.id
  target_type = "instance"

  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group_attachment" "grafana_attach" {
  count            = length(aws_instance.monitoring)
  target_group_arn = aws_lb_target_group.grafana_tg.arn
  target_id        = aws_instance.monitoring[count.index].id
  port             = 30000
}

resource "aws_lb_target_group_attachment" "prometheus_attach" {
  count            = length(aws_instance.monitoring)
  target_group_arn = aws_lb_target_group.prometheus_tg.arn
  target_id        = aws_instance.monitoring[count.index].id
  port             = 30090
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.monitoring_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Monitoring ALB"
      status_code  = "200"
    }
  }
}

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
