resource "docker_container" "frontend" {
  image = var.image
  name  = var.container_name
  ports {
    internal = 80
    external = 80
  }
  networks_advanced {
    name    = var.external_network_name
    aliases = ["external-frontend"]
  }
  networks_advanced {
    name    = var.internal_network_name
    aliases = ["internal-frontend"]
  }
  depends_on = var.depends_on
  restart    = "always"
}