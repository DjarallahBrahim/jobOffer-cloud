resource  "google_compute_network" "default" {
  name                    = "custom_vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "compute_subnet" {
  name          = "compute-subnet"
  region        = "var.region"
  network       = google_compute_network.default.id
  ip_cidr_range = "10.0.0.0/24"
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "sql_subnet" {
  name          = "sql-subnet"
  region        = "var.region"
  network       = google_compute_network.default.id
  ip_cidr_range = "10.0.1.0/24"
  private_ip_google_access = true
}

resource  "google_compute_subnetwork" "cloudrun_subnet" {
  name          = "cloudrun-subnet"
  region        = "var.region"
  network       = google_compute_network.default.id
  ip_cidr_range = "10.0.2.0/24"
  private_ip_google_access = false
}