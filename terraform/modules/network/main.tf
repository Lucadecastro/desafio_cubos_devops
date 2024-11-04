# Define rede externa (acessível a usuários)
resource "docker_network" "external_net" {
  name   = "external-net"
  driver = "bridge"
}

# Define rede interna (acessível apenas ao front, back e banco)
resource "docker_network" "internal_net" {
  name   = "internal-net"
  driver = "bridge"
}