terraform {
    required_providers {
        kubectl = {
            source  = "gavinbunney/kubectl"
            version = ">= 1.7.0"
         }
    }
}



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
  default_max_pods_per_node = 40
  deletion_protection = false
  node_pools = [
    {
      name               = "gke-pool"
      machine_type       = "e2-standard-2"
      disk_size_gb       = 100
      min_count          = 1
      max_count          = 2
      auto_upgrade       = true
      auto_repair        = true
      preemptible        = false
    }
  ]
}



resource "time_sleep" "wait_30_seconds" {
  depends_on = [module.gke]
  create_duration = "60s"
}

module "gke_auth" {
  depends_on           = [time_sleep.wait_30_seconds]
  source               = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  project_id           = var.project_id
  cluster_name         = module.gke.name
  location             = var.region
  use_private_endpoint = false
}

provider "kubectl" {
  host                   = module.gke_auth.host
  cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
  token                  = module.gke_auth.token
  load_config_file       = false
}

data "kubectl_file_documents" "namespace" {
    
    content = file("${path.module}/../../manifests/argocd/namespace.yaml")
} 

# Fetch the manifest from an HTTP URL
data "http" "argocd_manifest" {
  url = "https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
}

# Extract the YAML documents from the fetched content
data "kubectl_file_documents" "argocd" {
  content = data.http.argocd_manifest.body
}


resource "kubectl_manifest" "namespace" {
    depends_on = [module.gke_auth] # Ensure namespace creation waits for GKE auth setup
    count     = length(data.kubectl_file_documents.namespace.documents)
    yaml_body = element(data.kubectl_file_documents.namespace.documents, count.index)
    override_namespace = "argocd"
}

# Apply the manifest to the Kubernetes cluster
resource "kubectl_manifest" "argocd" {
  depends_on = [
    kubectl_manifest.namespace, module.gke_auth
  ]
  count     = length(data.kubectl_file_documents.argocd.documents)
  yaml_body = element(data.kubectl_file_documents.argocd.documents, count.index)
  override_namespace = "argocd"
}


data "kubectl_file_documents" "my-nginx-app" {
    content = file("${path.module}/../../manifests/argocd/jobstream.yaml")
}

resource "kubectl_manifest" "my-nginx-app" {
    depends_on = [
      kubectl_manifest.argocd,
    ]
    count     = length(data.kubectl_file_documents.my-nginx-app.documents)
    yaml_body = element(data.kubectl_file_documents.my-nginx-app.documents, count.index)
    override_namespace = "argocd"
}