locals {
  name = var.project_name
}

resource "random_id" "suffix" {
  byte_length = 3
}

############################
# Cloud SQL (PostgreSQL)
############################
resource "google_sql_database_instance" "this" {
  name             = "${local.name}-sql-${random_id.suffix.hex}"
  database_version = "POSTGRES_15"
  region           = var.region

  settings {
    tier = "db-f1-micro"
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
# Cloud Run service
############################
resource "google_cloud_run_v2_service" "this" {
  name     = "${local.name}-svc"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
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

# Allow public (unauthenticated) access
resource "google_cloud_run_v2_service_iam_member" "public" {
  name     = google_cloud_run_v2_service.this.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}
