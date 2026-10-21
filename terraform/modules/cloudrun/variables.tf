variable "name_prefix" {
  type = string
}
variable "region" {
  type = string
}
variable "environment" {
  type = string
}
variable "container_image" {
  type = string
}
variable "db_tier" {
  type = string
}
variable "db_user" {
  type = string
}
variable "db_password" {
  type      = string
  sensitive = true
}
