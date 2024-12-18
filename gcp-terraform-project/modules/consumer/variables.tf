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



variable "network_id" {
  description = "The network_id of vpc"
  type        = string
}


variable "subnet_id" {
  description = "The network_id of vpc"
  type        = string
}

variable "cos_image_name" {
  description = "The cos_image_name of vm"
  type        = string
}


variable "client_email" {
  description = "The client_email of account user"
  type        = string
}