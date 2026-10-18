variable "aws_region" {
  description = "Región de despliegue en AWS"
  type        = string
  default     = "eu-west-1"
}

variable "instance_type" {
  description = "Tipo de instancia EC2 para la infraestructura"
  type        = string
  default     = "t3.medium" # Suficiente para Docker, Prometheus y Grafana
}

variable "key_name" {
  description = "Nombre de la clave SSH para acceder a la instancia"
  type        = string
}
