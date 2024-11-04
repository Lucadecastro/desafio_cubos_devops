terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"
    }
  }
}

resource "docker_container" "prometheus" {
  image = var.image
  name  = var.container_name
  ports {
    internal = 9090
    external = 9090
  }
  volumes {
    host_path      = abspath(var.config_path)
    container_path = "/etc/prometheus/prometheus.yml"
  }
  networks_advanced {
    name    = var.network_name
    aliases = ["prometheus"]
  }
  restart = "always"
}