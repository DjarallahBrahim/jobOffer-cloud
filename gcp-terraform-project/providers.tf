terraform {
    required_providers {
        google= {
            source = "hashicorp/google"
            version = "~> 6.0.0"
        }
    }
}

provider "google" {
    credentials = file("~/.gcp/terraform-key.json")
    project = var.project_id
    region = var.region
}