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

# MySQL DNS Record
resource "google_dns_record_set" "mysql_dns_record" {
  name         = "mysql.jobstream."  # Define the desired DNS name
  managed_zone = google_dns_managed_zone.private_dns.name
  type         = "A"                         # Type A record for IP resolution
  ttl          = 300                         # Time to Live for the DNS record

  # Use the private IP of the MySQL instance
  rrdatas = [google_sql_database_instance.instance.private_ip_address]
}