variable "image" {
  description = "Image for the backend container"
  type        = string
}

variable "container_name" {
  description = "Name of the backend container"
  type        = string
}

variable "db_user" {
  description = "Database user for the backend"
  type        = string
}

variable "db_pass" {
  description = "Database password for the backend"
  type        = string
  sensitive   = true
}

variable "db_host" {
  description = "Database host for the backend"
  type        = string
}

variable "db_port" {
  description = "Database port for the backend"
  type        = string
}

variable "db_name" {
  description = "Database name for the backend"
  type        = string
}

variable "network_name" {
  description = "Network name for the backend container"
  type        = string
}