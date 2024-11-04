variable "image" {
  description = "Image for the Grafana container"
  type        = string
}

variable "container_name" {
  description = "Name of the Grafana container"
  type        = string
}

variable "network_name" {
  description = "Network name for the Grafana container"
  type        = string
}

variable "depends_on" {
  description = "Dependencies for the Grafana container"
  type        = list(string)
  default     = []
}