output "instance_name" {
  description = "The name of the SQL instance"
  value       = google_sql_database_instance.instance.name
}

output "db_user" {
  description = "The database user name"
  value       = google_sql_user.default.name
}

output "private_ip" {
  description = "The private IP address range for the database"
  value       = google_compute_global_address.private_ip_address.address
}

output "private_ip_address" {
  description = "The private IP address of the MySQL instance"
  value       = google_sql_database_instance.instance.private_ip_address
}