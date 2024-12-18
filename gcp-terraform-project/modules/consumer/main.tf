# ... (Existing code for the first instance) ...

# Second instance with different image and environment variables
resource "google_compute_instance" "consumer_instance" {
  project      = var.project_id
  name         = "consumer-service"
  machine_type = "e2-standard-2"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.cos_image_name  # Replace with your second image name
    }
  }

  network_interface {
    subnetwork_project = var.network_id
    subnetwork         = var.subnet_id
    access_config {}
  }

  tags = ["consumer-service"]

  metadata = {
    gce-container-declaration =<<EOT
spec:
  containers:
    - image: djarallahbrahim/job-offer-consumer-ws:main
      name: job-offer-consumer-ws
      securityContext:
        privileged: false
      env:
        - name: SPRING_APPLICATION_NAME
          value: joboffer consumer
        - name: SERVER_PORT
          value: "8089"
        - name: SPRING_KAFKA_CONSUMER_BOOTSTRAP_SERVERS
          value: kafka.service.jobstream:9092
        - name: SPRING_KAFKA_CONSUMER_GROUP_ID
          value: job-offer-created-events
        - name: SPRING_KAFKA_CONSUMER_PROPERTIES_SPRING_JSON_TRUSTED_PACKAGES
          value: "*"
        - name: TOPIC_KAFKA_NAME
          value: job-offer-events-topic
        - name: SPRING_DATASOURCE_URL
          value: jdbc:mysql://mysql.jobstream:3306/jobstream
        - name: SPRING_DATASOURCE_USERNAME
          value: root
        - name: SPRING_DATASOURCE_PASSWORD
          value: r00t
        - name: SPRING_DATASOURCE_DRIVER_CLASS_NAME
          value: com.mysql.cj.jdbc.Driver
        - name: SPRING_JPA_HIBERNATE_DDL_AUTO
          value: update
        - name: SPRING_JPA_SHOW_SQL
          value: "true"
        - name: SPRING_JPA_PROPERTIES_HIBERNATE_DIALECT
          value: org.hibernate.dialect.MySQLDialect
        - name: SPRING_MAIL_HOST
          value: smtp.gmail.com
        - name: SPRING_MAIL_PORT
          value: "587"
        - name: SPRING_MAIL_USERNAME
          value: senderjoboffer@gmail.com
        - name: SPRING_MAIL_PASSWORD
          value: ylyo yslg gbqq yhdg
        - name: SPRING_MAIL_PROPERTIES_MAIL_SMTP_AUTH
          value: "true"
        - name: SPRING_MAIL_PROPERTIES_MAIL_SMTP_STARTTLS_ENABLE
          value: "true"
        - name: logging.level.org.apache.kafka
          value: INFO
        - name: logging.level.org.springframework.kafka
          value: INFO
      stdin: false
      tty: false
      volumeMounts: []
  restartPolicy: Always
  volumes: []
EOT

    google-logging-enabled    = "true"
    google-monitoring-enabled = "true"
  }

  labels = {
    container-vm = "consumer-service"
  }

  service_account {
    email = var.client_email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  lifecycle {
    ignore_changes = [
      network_interface[0].subnetwork_project,
      metadata["ssh-keys"]
    ]
  }
}
