terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"
    }
  }
}

# Define provedor Docker, permite interação do Terraform com a API do docker
provider "docker" {}

# Define rede externa (acessível a usuários)
resource "docker_network" "external_net" {
  name = "external-net"
  driver = "bridge"
}

# Define rede interna (acessível apenas ao front, back e banco)
resource "docker_network" "internal_net" {
  name = "internal-net"
  driver = "bridge"
}

# Define Docker Volume para persistência de dados do PostgreSQL
resource "docker_volume" "pgdata" {
  name = "pgdata"
}

# Container do PostgreSQL
resource "docker_container" "postgres" {
  image = "postgres:15.8"
  name  = "postgres"
  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_pass}",
    "POSTGRES_DB=desafio"
  ]
  volumes {
    volume_name  = docker_volume.pgdata.name
    container_path = "/var/lib/postgresql/data" #volume para persistência de dados
  }
  volumes {
    host_path      = "${abspath("${path.module}/../sql/script.sql")}"
    container_path = "/docker-entrypoint-initdb.d/init.sql"
  }
  networks_advanced {
    name = docker_network.internal_net.name
    aliases = ["postgres"]
  }
  restart = "always"
}

# Container do Backend
resource "docker_container" "backend" {
  image = "desafio-tecnico-backend:latest"
  name  = "backend"
  env = [
    "DB_USER=${var.db_user}",
    "DB_PASS=${var.db_pass}",
    "DB_HOST=postgres",
    "DB_PORT=5432",
    "DB_NAME=desafio"
  ]
  networks_advanced {
    name = docker_network.internal_net.name
    aliases = ["backend"]
  }
  depends_on = [docker_container.postgres]
  restart = "always"
}

#Container do Frontend
resource "docker_container" "frontend" {
  image = "desafio-tecnico-frontend:latest"
  name  = "frontend"
  ports {
    internal = 80
    external = 80
  }
  networks_advanced {
    name = docker_network.external_net.name
    aliases = ["external-rontend"]
  }
  networks_advanced {
    name = docker_network.internal_net.name
    aliases = ["internal-frontend"]
  }
  depends_on = [docker_container.backend]
  restart = "always"
}

# Container do Prometheus
resource "docker_container" "prometheus" {
  image = "prom/prometheus:latest"
  name = "prometheus"
  ports {
  internal = 9090
  external = 9090
  }
  volumes {
    host_path = "${abspath("${path.module}/../prometheus.yml")}"
    container_path = "/etc/prometheus/prometheus.yml"
  }
  networks_advanced {
    name = docker_network.internal_net.name
    aliases = ["prometheus"]
  }
  restart = "always"
}

# Container do Grafana
resource "docker_container" "grafana"  {
  image = "grafana/grafana:latest"
  name  = "grafana"
  ports {
    internal = 3000
    external = 3000
  }
  networks_advanced {
    name = docker_network.internal_net.name
    aliases = ["grafana"]
  }
  depends_on = [docker_container.prometheus]
  restart = "always"
}
