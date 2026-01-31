output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "monitoring_private_ips" {
  value = aws_instance.monitoring[*].private_ip
}

output "app_private_ip" {
  value = aws_instance.app.private_ip
}
