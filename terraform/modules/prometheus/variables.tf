variable "image" {
  description = "Image for the Prometheus container"
  type        = string
}

variable "container_name" {
  description = "Name of the Prometheus container"
  type        = string
}

variable "network_name" {
  description = "Network name for the Prometheus container"
  type        = string
}

variable "config_path" {
  description = "Path to the Prometheus configuration file"
  type        = string
}