terraform {
  backend "remote" {
    organization = "PI-2-ASIR"

    workspaces {
      name = "PI2-Johann-Fran"
    }
  }

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}

# 1. DEFINICIÓN DE REDES
resource "docker_network" "red_backend" {
  name = "red-backend"
}

resource "docker_network" "red_monitoreo" {
  name = "red-monitoreo"
}

# 2. CONTENEDOR: MARIADB (Base de Datos)
resource "docker_container" "mariadb" {
  name  = "contenedor-mariadb"
  image = "mariadb:latest"
  env = [
    "MYSQL_ROOT_PASSWORD=mi_clave_secreta",
    "MYSQL_DATABASE=mi_web_db"
  ]
  networks_advanced {
    name = docker_network.red_backend.name
  }
  # No exponemos puertos al host por seguridad, solo accesible por Apache
}

# 3. CONTENEDOR: APACHE (Servidor Web)
resource "docker_container" "apache" {
  name  = "contenedor-apache"
  image = "httpd:latest"
  ports {
    internal = 80
    external = 8080
  }
  # Conectado a ambas redes: habla con la BD y permite que lo monitoreen
  networks_advanced {
    name = docker_network.red_backend.name
  }
  networks_advanced {
    name = docker_network.red_monitoreo.name
  }
}

# 4. CONTENEDOR: PROMETHEUS (Métricas)
resource "docker_container" "prometheus" {
  name  = "contenedor-prometheus"
  image = "prom/prometheus:latest"
  ports {
    internal = 9090
    external = 9090
  }
  networks_advanced {
    name = docker_network.red_monitoreo.name
  }

 # AÑADE ESTO: Conecta tu archivo local con el interior del contenedor
  volumes {
    host_path      = "${path.cwd}/prometheus.yml"
    container_path = "/etc/prometheus/prometheus.yml"
  }
}
# 5. CONTENEDOR: GRAFANA (Visualización)
resource "docker_container" "grafana" {
  name  = "contenedor-grafana"
  image = "grafana/grafana:latest"
  ports {
    internal = 3000
    external = 3000
  }
  networks_advanced {
    name = docker_network.red_monitoreo.name
  }
}
