variable "image" {
  description = "Image for the frontend container"
  type        = string
}

variable "container_name" {
  description = "Name of the frontend container"
  type        = string
}

variable "external_network_name" {
  description = "External network name for the frontend container"
  type        = string
}

variable "internal_network_name" {
  description = "Internal network name for the frontend container"
  type        = string
}
