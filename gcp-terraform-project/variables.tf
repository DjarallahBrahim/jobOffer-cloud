variable "project_id" {
  description = "The project ID to host jobstream application in"
  default     = "credible-bridge-440508-u0"
  type        = string
}

variable "region" {
  description = "The region where resources will be created"
  default     = "us-central1"
  type        = string
}

variable "zone" {
  description = "The GCP zone to deploy resources in"
  type        = string
  default     = "us-central1-a"  # You can change this based on your preference
}

variable "cos_image_name" {
  description = "The Container-Optimized OS image for VM instances"
  type        = string
  default     = "cos-stable-117-18613-75-26"  # Update this if using a different version
}

variable "subnetwork_project" {
  description = "The project that contains the subnetwork"
  type        = string
  default     = "jobstream"  # This is the same project as your `project_id`
}

variable "subnetwork" {
  description = "The subnetwork where resources will be created"
  type        = string
  default     = "compute-subnet"  # The name of the subnet you created in the VPC setup
}

variable "client_email" {
  description = "The email of the service account to be used by the VM"
  type        = string
  default     = "kafka-instance@credible-bridge-440508-u0.iam.gserviceaccount.com"  # Replace with actual service account email
}

variable "db_root_password" {
  description = "password for db user"
  type        = string
  default     = "samtyga"
}

variable "terraform_state_file_version" {
  description = "terraform-state-file-version"
  type        = string
  default     = "0-2"
}