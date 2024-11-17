terraform {
    required_providers {
        google= {
            source = "hashicorp/google"
            version = "4.51.0"
        }
    }
}

provider "google" {
    credentials = file("terraform-gcp-service-account.json")
    project = var.project_id
    region = var.region
}