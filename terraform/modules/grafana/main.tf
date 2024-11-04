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
  depends_on = var.depends_on
  restart    = "always"
}