output "internal_net_name" {
  value = docker_network.internal_net.name
}

output "external_net_name" {
  value = docker_network.external_net.name
}