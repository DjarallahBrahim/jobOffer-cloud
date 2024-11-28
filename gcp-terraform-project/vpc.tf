resource  "google_compute_network" "default" {
  name                    = "custom-vpc"
  auto_create_subnetworks = "false"

}

resource "google_compute_subnetwork" "compute_subnet" {
  name          = "compute-subnet"
  region        = var.region
  network       = google_compute_network.default.id
  ip_cidr_range = "10.0.0.0/24"
  private_ip_google_access = true
  
}

resource "google_compute_subnetwork" "sql_subnet" {
  name          = "sql-subnet"
  region        = var.region
  network       = google_compute_network.default.id
  ip_cidr_range = "10.0.1.0/24"
  private_ip_google_access = true
}

resource  "google_compute_subnetwork" "cloudrun_subnet" {
  name          = "cloudrun-subnet"
  region        = var.region
  network       = google_compute_network.default.id
  ip_cidr_range = "10.0.2.0/24"
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "cluster_subnet" {
  name          = "cluster-subnet"
  region        = var.region
  network       = google_compute_network.default.id
  ip_cidr_range = "10.0.3.0/18"
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "192.168.0.0/18"
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "192.168.1.0/18"
  }
}
