resource "google_compute_global_address" "private_ip_address" {
  name          = var.network_name
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.network_name
}

resource "google_service_networking_connection" "private_vpc_connection" {
    network       = var.network_self_link
    service       = "servicenetworking.googleapis.com"
    reserved_peering_ranges = ["${google_compute_global_address.private_ip_address.name}"]
}


resource "google_sql_database_instance" "instance" {
  depends_on = [google_service_networking_connection.private_vpc_connection]
  name             = "mysql-instance"
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled   = false
      private_network = "projects/credible-bridge-440508-u0/global/networks/${var.network_name}"
    }
  }
}


resource "google_sql_database" "default" {
  name     = var.db_name
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "default" {
  name     = var.db_user
  instance = google_sql_database_instance.instance.name
  password = var.db_password
}