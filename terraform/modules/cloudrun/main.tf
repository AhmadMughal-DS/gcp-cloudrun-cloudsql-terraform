locals {
  labels = {
    project     = var.name_prefix
    environment = var.environment
    managed_by  = "terraform"
    owner       = "muhammad-ahmad"
  }
}

resource "random_id" "suffix" {
  byte_length = 3
}

resource "google_service_account" "run" {
  account_id   = "${var.name_prefix}-run"
  display_name = "Cloud Run runtime SA"
}

############################
# Cloud SQL (backups, SSL-only)
############################
resource "google_sql_database_instance" "this" {
  name             = "${var.name_prefix}-sql-${random_id.suffix.hex}"
  database_version = "POSTGRES_15"
  region           = var.region

  settings {
    tier = var.db_tier

    backup_configuration {
      enabled = true
    }
    ip_configuration {
      ssl_mode = "ENCRYPTED_ONLY"
    }
  }

  deletion_protection = false
}

resource "google_sql_database" "this" {
  name     = "appdb"
  instance = google_sql_database_instance.this.name
}

resource "google_sql_user" "this" {
  name     = var.db_user
  instance = google_sql_database_instance.this.name
  password = var.db_password
}

############################
# Cloud Run
############################
resource "google_cloud_run_v2_service" "this" {
  name     = "${var.name_prefix}-svc"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = google_service_account.run.email
    labels          = local.labels

    containers {
      image = var.container_image
      ports {
        container_port = 8080
      }
      env {
        name  = "DB_CONNECTION_NAME"
        value = google_sql_database_instance.this.connection_name
      }
      env {
        name  = "DB_NAME"
        value = google_sql_database.this.name
      }
    }
  }
}

resource "google_cloud_run_v2_service_iam_member" "public" {
  name     = google_cloud_run_v2_service.this.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}
