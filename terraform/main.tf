module "backend" {
  source         = "./modules/backend"
  image          = "desafio-tecnico-backend:latest"
  container_name = "backend"
  db_user        = var.db_user
  db_pass        = var.db_pass
  db_host        = var.db_host
  db_port        = var.db_port
  db_name        = var.db_name
  network_name   = docker_network.internal_net.name
  depends_on     = [module.postgres]
}

module "frontend" {
  source                = "./modules/frontend"
  image                 = "desafio-tecnico-frontend:latest"
  container_name        = "frontend"
  external_network_name = docker_network.external_net.name
  internal_network_name = docker_network.internal_net.name
  depends_on            = [module.backend]
}

module "prometheus" {
  source         = "./modules/prometheus"
  image          = "prom/prometheus:latest"
  container_name = "prometheus"
  config_path    = "${path.module}/prometheus.yml"
  network_name   = docker_network.internal_net.name
}

module "grafana" {
  source         = "./modules/grafana"
  image          = "grafana/grafana:latest"
  container_name = "grafana"
  network_name   = docker_network.internal_net.name
  depends_on     = [module.prometheus]
}