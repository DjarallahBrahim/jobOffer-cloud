resource "google_cloud_run_v2_service" "frontend" {
  name     = "react-frontend"
  location = var.region
    ingress = "INGRESS_TRAFFIC_ALL"
      deletion_protection = false
  template {

 
    vpc_access{
      network_interfaces {
        network = google_compute_network.default.id
        subnetwork = google_compute_subnetwork.cloudrun_subnet.id
        tags = ["react-frontend"]
      }
    }

    scaling {
      max_instance_count = 5
      min_instance_count= 1
    }
      containers {
        image = "djarallahbrahim/jobstream-front:0.0.4"
        ports {
            container_port = 80
          }
        env {
          name = "MY_APP_API_BASE_URL"
          value = "https://job-offer-producer-416597012245.us-central1.run.app"
        }
        resources {
          limits = {
            "cpu" = "2"
            "memory" = "4Gi"
          }
        }
      }
  }
  
}

resource "google_cloud_run_service_iam_policy" "public_access" {
  service = google_cloud_run_v2_service.frontend.name
  location = google_cloud_run_v2_service.frontend.location
  policy_data = data.google_iam_policy.public_iam_policy.policy_data
}


data "google_iam_policy" "public_iam_policy" {
  binding {
    role = "roles/run.invoker"
    members = ["allUsers"]
  }
}