# Container do Backend
resource "docker_container" "backend" {
  image = var.image
  name  = var.container_name
  env = [
    "DB_USER=${var.db_user}",
    "DB_PASS=${var.db_pass}",
    "DB_HOST=${var.db_host}",
    "DB_PORT=${var.db_port}",
    "DB_NAME=${var.db_name}"
  ]
  networks_advanced {
    name    = var.network_name
    aliases = ["backend"]
  }
  depends_on = var.depends_on
  restart    = "always"
}