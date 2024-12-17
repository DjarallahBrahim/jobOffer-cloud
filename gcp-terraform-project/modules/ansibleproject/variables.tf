variable "gcp_project" {
  type        = string
  default     = "credible-bridge-440508-u0"
}
variable "gcp_zone" {
  type        = string
  default     = "us-central1-a"
}

variable "gcp_region" {
  type        = string
  default     = "us-central1"
}

variable "ci_runner_instance_type" {
  type        = string
  default     = "e2-micro"
}
variable "hostname" {
  type        = string
  default     = "gitlab-runner.example.com"
}