output "monitoring_private_ips" {
  value = aws_instance.monitoring[*].private_ip
}

