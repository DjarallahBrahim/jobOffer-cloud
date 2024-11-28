module "gke" {
  source                    = "terraform-google-modules/kubernetes-engine/google"
  version                   = "~> 33.0" # Recent stable version
  project_id                = var.project_id
  name                      = "gke-cluster"
  region                    = var.region
  network                   = var.network_name
  subnetwork                = var.subnetwork_name
  create_service_account      = false
  service_account             = var.service_account
  ip_range_pods             = "pod-ranges" # Specify secondary range for Pods
  ip_range_services         = "services-range" # Specify secondary range for Services
  remove_default_node_pool  = true
  initial_node_count        = 1
  network_policy            = true
default_max_pods_per_node = 25
  node_pools = [
    {
      name               = "gke-pool"
      machine_type       = "e2-standard-2"
      disk_size_gb       = 100
      min_count          = 1
      max_count          = 1
      auto_upgrade       = true
      auto_repair        = true
      preemptible        = false
    }
  ]
}
