resource "docker_volume" "pgdata" {
  name = "pgdata"
}

resource "docker_container" "postgres" {
  image = "postgres:15.8"
  name  = "postgres"
  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_pass}",
    "POSTGRES_DB=desafio"
  ]
  volumes {
    volume_name    = docker_volume.pgdata.name
    container_path = "/var/lib/postgresql/data"
  }
  volumes {
    host_path      = var.init_script_path
    container_path = "/docker-entrypoint-initdb.d/init.sql"
  }
  networks_advanced {
    name    = var.network_name
    aliases = ["postgres"]
  }
  restart = "always"
}