resource "google_dns_managed_zone" "private_dns" {
  name        = "kafka-private-dns"
  dns_name    = "jobstream."
  description = "Private DNS zone for internal resources"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.default.id
    }
  }
}

resource "google_dns_record_set" "kafka_dns_record" {
  name         = "kafka.service.jobstream."
  managed_zone = google_dns_managed_zone.private_dns.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_instance.kafka_instance.network_interface[0].network_ip]
}
