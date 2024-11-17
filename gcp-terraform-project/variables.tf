variable "project_id" {
  description = "The project ID to host jobstream application in"
  default     = "jobstream"
  type        = string
}

variable "region" {
  description = "The region where resources will be created"
  type        = string
  default     = "us-central1"
}
