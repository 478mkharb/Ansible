output "monitoring_private_ips" {
  value = aws_instance.monitoring[*].private_ip
}

output "alb_dns_name" {
  value = aws_lb.monitoring_alb.dns_name
}
