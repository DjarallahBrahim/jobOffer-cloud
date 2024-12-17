module "gce-container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 3.0"

  cos_image_name = var.cos_image_name

  container = {
    image = "bitnami/kafka:latest"  # Kafka Docker image

    env = [
  {
    name  = "KAFKA_CFG_NODE_ID"
    value = "1"
  },
  {
    name  = "KAFKA_KRAFT_CLUSTER_ID"
    value = "tF0HTgFQTO-xH1eBLFOpLg"
  },
  {
    name  = "KAFKA_CFG_PROCESS_ROLES"
    value = "controller,broker"
  },
  {
    name  = "KAFKA_CFG_CONTROLLER_QUORUM_VOTERS"
    value = "1@kafka.service.jobstream:9091"
  },
  {
    name  = "KAFKA_CFG_LISTENERS"
    value = "PLAINTEXT://:9090,CONTROLLER://:9091,EXTERNAL://:9092"
  },
  {
    name  = "KAFKA_CFG_ADVERTISED_LISTENERS"
    value = "PLAINTEXT://kafka.service.jobstream:9090,EXTERNAL://kafka.service.jobstream:9092"
  },
  {
    name  = "KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP"
    value = "CONTROLLER:PLAINTEXT,EXTERNAL:PLAINTEXT,PLAINTEXT:PLAINTEXT"
  },
  {
    name  = "KAFKA_CFG_CONTROLLER_LISTENER_NAMES"
    value = "CONTROLLER"
  },
  {
    name  = "KAFKA_CFG_INTER_BROKER_LISTENER_NAME"
    value = "PLAINTEXT"
  }
]


    volumeMounts = [
      {
        mountPath = "/bitnami/kafka"
        name      = "kafka-volume"
        readOnly  = false
      },
    ]
  }

  volumes = [
    {
      name = "kafka-volume"
      emptyDir = {
        medium = "Memory"  # In-memory volume, can change to persistent disk later
      }
    },
  ]

  restart_policy = "Always"
}

resource "google_compute_instance" "kafka_instance" {
  project      = var.project_id
  name         = "kafka-service"
  machine_type = "e2-custom-medium-2816"  # Using e2-small as per your previous decision
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = module.gce-container.source_image
    }
  }

  network_interface {
    subnetwork_project = google_compute_network.default.id
    subnetwork         = google_compute_subnetwork.compute_subnet.id  # Using the subnet created in step 1
    access_config {}  # No external IP by default
  }

  lifecycle {
    ignore_changes = [
      network_interface[0].subnetwork_project,
      metadata["ssh-keys"]
    ]
  }

  tags = ["kafka-service"]

  metadata = {
    gce-container-declaration = module.gce-container.metadata_value
    google-logging-enabled    = "true"
    google-monitoring-enabled = "true"
  }

  labels = {
    container-vm = module.gce-container.vm_container_label
  }

  service_account {
    email = var.client_email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}