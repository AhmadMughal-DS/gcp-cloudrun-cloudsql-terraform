output "cloud_run_url" {
  value = google_cloud_run_v2_service.this.uri
}
output "sql_connection_name" {
  value = google_sql_database_instance.this.connection_name
}
