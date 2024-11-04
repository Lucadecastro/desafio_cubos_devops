terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"
    }
  }
}

resource "docker_container" "grafana" {
  image = var.image
  name  = var.container_name
  ports {
    internal = 3000
    external = 3000
  }
  networks_advanced {
    name    = var.network_name
    aliases = ["grafana"]
  }
  restart    = "always"
}