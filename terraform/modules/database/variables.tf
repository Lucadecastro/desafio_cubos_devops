variable "db_user" {
  type        = string
  description = "Database user"
}

variable "db_pass" {
  type        = string
  description = "Database password"
  sensitive   = true
}

variable "network_name" {
  type        = string
  description = "Name of the network to attach"
}

variable "init_script_path" {
  type        = string
  description = "Path to the database initialization script"
}