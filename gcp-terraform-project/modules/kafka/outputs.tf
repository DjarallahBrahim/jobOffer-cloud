output "kafka_instance_ip_adresse" {
  description = "The private IP address of the MySQL instance"
  value       = google_compute_instance.kafka_instance.network_interface[0].network_ip
}