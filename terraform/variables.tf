variable "db_user" {
  description = "PostgreSQL database user"
  type    = string
  default = "username"
}

variable "db_pass" {
  description = "PostgreSQL database password"
  type    = string
  sensitive = true
  default = "password"
}