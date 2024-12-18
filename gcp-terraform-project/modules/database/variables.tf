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



variable "network_name" {
  description = "The network_name of vpc"
  type        = string
}

variable "network_self_link" {
  description = "The self link of the VPC network"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "jobstream"
}

variable "db_user" {
  description = "The database username"
  type        = string
  default     = "root"
}

variable "db_password" {
  description = "The password for the database user"
  type        = string
}

