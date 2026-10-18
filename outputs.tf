output "public_ip" {
  description = "Dirección IP pública de la instancia de infraestructura"
  value       = aws_instance.servidor_monotorizacion.public_ip
}

output "grafana_url" {
  description = "URL de acceso a Grafana"
  value       = "http://${aws_instance.servidor_monotorizacion.public_ip}:3000"
}

output "prometheus_url" {
  description = "URL de acceso a Prometheus"
  value       = "http://${aws_instance.servidor_monotorizacion.public_ip}:9090"
}
