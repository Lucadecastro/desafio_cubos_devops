terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"
    }
  }
}

provider "docker" {}

module "network" {
  source = "./modules/network"
}

module "database" {
  source            = "./modules/database"
  db_user           = var.db_user
  db_pass           = var.db_pass
  network_name      = module.network.internal_net_name
  init_script_path  = "../sql/script.sql"
}

module "backend" {
  source         = "./modules/backend"
  image          = "desafio-tecnico-backend:latest"
  container_name = "backend"
  db_user        = var.db_user
  db_pass        = var.db_pass
  db_host        = var.db_host
  db_port        = var.db_port
  db_name        = var.db_name
  network_name   = module.network.internal_net_name
  depends_on     = [module.database]
}

module "frontend" {
  source                = "./modules/frontend"
  image                 = "desafio-tecnico-frontend:latest"
  container_name        = "frontend"
  external_network_name = module.network.external_net_name
  internal_network_name = module.network.internal_net_name
  depends_on            = [module.backend]
}

module "prometheus" {
  source         = "./modules/prometheus"
  image          = "prom/prometheus:latest"
  container_name = "prometheus"
  config_path    = "../prometheus.yml"
  network_name   = module.network.internal_net_name
}

module "grafana" {
  source         = "./modules/grafana"
  image          = "grafana/grafana:latest"
  container_name = "grafana"
  network_name   = module.network.internal_net_name
  depends_on     = [module.prometheus]
}