variable "db_user" {
  description = "PostgreSQL database user"
  type        = string
  default     = "username"
}

variable "db_pass" {
  description = "PostgreSQL database password"
  type        = string
  sensitive   = true
  default     = "password"
}

variable "db_host" {
  description = "PostgreSQL host name"
  type        = string
  default     = "postgres"
}

variable "db_port" {
  description = "PostgreSQL port number"
  type        = string
  default     = "5432"
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "desafio"
}