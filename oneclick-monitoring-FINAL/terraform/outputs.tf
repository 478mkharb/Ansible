output "monitoring_private_ips" {
  value = aws_instance.monitoring[*].private_ip
}

output "app_private_ip" {
  value = aws_instance.app.private_ip
}
