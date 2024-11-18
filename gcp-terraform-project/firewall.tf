resource  "google_compute_firewall" "allow_internal_communication" {
    name = "allow-interna-communicaion"
    network = google_compute_network.default.id
    allow {
        protocol = "tcp"
        ports = ["0-65535"]
    }

    source_ranges = ["10.0.0.0/8"]
    # Allow all internal TCP traffic within the VPC (between Kafka, producer, consumer, MySQL)
    target_tags = [
    "kafka-service",    # For Kafka instances
    "producer-service", # For Producer instances
    "consumer-service"  # For Consumer instances
    ]
}


resource "google_compute_firewall" "allow_react_http" {
    name = "allow-react-http"
    network = google_compute_network.default.id

    # Allow HTTP and HTTPS traffic for React frontend Cloud Run service
    allow {
        protocol = "tcp"
        ports = ["80", "443"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags = ["react-frontend"]
}

# Firewall to allow Kafka communication (Kafka & Producer services)
resource "google_compute_firewall" "allow_kafka_producer" {
  name    = "allow-kafka-producer"
  network = google_compute_network.default.id

  # Allow Kafka communication on port 9092
  allow {
    protocol = "tcp"
    ports    = ["9092"]
  }

  # Internal VPC range for secure communication
  source_ranges = ["10.0.0.0/8"]
  
  # Target tags for Kafka and Producer services
  target_tags = [
    "kafka-service",    # Kafka instance
    "producer-service"  # Producer instance (on Compute Engine or Cloud Run)
  ]
}

# Firewall to allow MySQL communication between instances (Producer, Consumer)
resource "google_compute_firewall" "allow_mysql_access" {
  name    = "allow-mysql-access"
  network = google_compute_network.default.id

  # Allow MySQL communication on port 3306
  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  # Internal VPC range for secure MySQL communication
  source_ranges = ["10.0.0.0/8"]
  
  # Target tag for MySQL database (Cloud SQL)
  target_tags = ["mysql-database"]
}

# Optional: Allow SSH access to instances for administrative purposes
resource "google_compute_firewall" "allow_ssh_access" {
  name    = "allow-ssh-access"
  network = google_compute_network.default.id

  # Allow SSH access on port 22
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Allow SSH access from anywhere (for management purposes)
  source_ranges = ["0.0.0.0/0"]
  
  # Target tags for all instances that need SSH access
  target_tags = [
    "kafka-service",    # Kafka instance
    "producer-service", # Producer instance
    "consumer-service"  # Consumer instance
  ]
}