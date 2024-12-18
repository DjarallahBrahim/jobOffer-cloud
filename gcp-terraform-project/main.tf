terraform {
  backend "gcs" {
    bucket = "terraform-remote-backend-0-2"
  }
}

resource "google_storage_bucket" "default" {
  name     = "terraform-remote-backend-${var.terraform_state_file_version}"
  location = var.region

  force_destroy               = true
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

module "database" {
  source = "./modules/database"

  region         = var.region
  network_name       = google_compute_network.default.name
  network_self_link  = google_compute_network.default.self_link
  db_name        = "jobstream"
  db_user        = "root"
  db_password    = "r00t" # Replace with secure input or use Secrets Manager
}

module "kafka" {
  source = "./modules/kafka"

  project_id = var.project_id
  zone       = var.zone
  cos_image_name = var.cos_image_name
  network_id       = google_compute_network.default.id
  subnet_id = google_compute_subnetwork.compute_subnet.id
  docker_image = var.kafka_image_docker
  client_email = var.client_email
}


# module "gke" {
#   source            = "./modules/gke" # Path to your GKE module
#   project_id        = var.project_id
#   region            = var.region
#   network_name      = google_compute_network.default.name
#   subnetwork_name   = google_compute_subnetwork.cluster_subnet.name
#   service_account             = var.service_account

# }