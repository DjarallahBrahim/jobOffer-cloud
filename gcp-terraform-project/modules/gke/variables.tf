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

variable "network_name" {
  description = "The project that contains the subnetwork"
  type        = string
}

variable "subnetwork_name" {
  description = "The subnetwork where resources will be created"
  type        = string
}


variable "service_account" {
  description = "service account fo cluster"
  type        = string
}