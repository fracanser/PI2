terraform {
  required_version = ">= 1.3.0"

  # Estado local (terraform.tfstate en esta carpeta): no requiere login en Terraform Cloud
  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  # Conexión por defecto con el socket local de Docker en la máquina.
  # Si Docker no responde, descomenta la línea que corresponda a tu sistema:
   host = "unix:///var/run/docker.sock"        # Linux / macOS
  # host = "npipe:////.//pipe//docker_engine"   # Windows
}
