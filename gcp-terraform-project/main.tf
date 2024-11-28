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
