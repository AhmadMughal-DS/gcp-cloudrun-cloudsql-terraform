variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "your-gcp-project-id"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "project_name" {
  description = "Name prefix applied to all resources"
  type        = string
  default     = "ahmad-cloudrun"
}

variable "container_image" {
  description = "Container image for the Cloud Run service"
  type        = string
  default     = "us-docker.pkg.dev/cloudrun/container/hello"
}

variable "db_user" {
  description = "Cloud SQL application user"
  type        = string
  default     = "appuser"
}

variable "db_password" {
  description = "Cloud SQL user password (pass via TF_VAR_db_password)"
  type        = string
  sensitive   = true
}
