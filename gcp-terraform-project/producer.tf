resource "google_cloud_run_v2_service" "producer" {
  name     = "job-offer-producer"
  location = var.region
    ingress = "INGRESS_TRAFFIC_ALL"
      deletion_protection = true
  template {


    vpc_access{
      network_interfaces {
        network = google_compute_network.default.id
        subnetwork = google_compute_subnetwork.cloudrun_subnet.id
        tags = ["producer-service"]
      }
    }

    scaling {
      max_instance_count = 5
      min_instance_count= 1
    }
      containers {
        image = "djarallahbrahim/job-offer-producer-ws:main"
        resources {
          limits = {
            "cpu" = "4"
            "memory" = "8Gi"
          }
        }
        env {
          name  = "SPRING_APPLICATION_NAME"
          value = "kafka-ws"
        }
        env {
          name  = "SPRING_KAFKA_PRODUCER_BOOTSTRAP_SERVERS"
          value = "kafka.service.jobstream:9092"
        }
        env {
          name  = "SPRING_KAFKA_BOOTSTRAP_SERVERS"
          value = "kafka.service.jobstream:9092"
        }
        env {
          name  = "SPRING_DATASOURCE_URL"
          value = "jdbc:mysql://mysql.jobstream:3306/jobstream"
        }

         env {
            name  = "SERVER_PORT"
            value = "8080"
          }
        env  {
            name  = "MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE"
            value = "*"
          }
        env  {
            name  = "SPRING_KAFKA_PRODUCER_KEY_SERIALIZER"
            value = "org.apache.kafka.common.serialization.StringSerializer"
          }
         env {
            name  = "SPRING_KAFKA_PRODUCER_VALUE_SERIALIZER"
            value = "org.springframework.kafka.support.serializer.JsonSerializer"
          }
        env  {
            name  = "SPRING_KAFKA_PRODUCER_ENABLE_IDEMPOTENCE"
            value = "true"
          }
        env  {
            name  = "SPRING_KAFKA_PRODUCER_MAX_IN_FLIGHT_REQUESTS_PER_CONNECTION"
            value = "5"
          }
        env  {
            name  = "SPRING_KAFKA_PRODUCER_ACKS"
            value = "all"
          }
        env  {
            name  = "SPRING_KAFKA_PRODUCER_PROPERTIES_LINGER_MS"
            value = "0"
          }
        env  {
            name  = "SPRING_KAFKA_PRODUCER_PROPERTIES_REQUEST_TIMEOUT_MS"
            value = "30000"
          }
        env  {
            name  = "SPRING_KAFKA_PRODUCER_PROPERTIES_DELIVERY_TIMEOUT_MS"
            value = "120000"
          }
        env  {
            name  = "TOPIC_KAFKA_NAME"
            value = "job-offer-events-topic"
          }
        env  {
            name  = "SPRING_DATASOURCE_USERNAME"
            value = "root"
          }
        env  {
            name  = "SPRING_DATASOURCE_PASSWORD"
            value = "r00t"
          }
        env  {
            name  = "SPRING_DATASOURCE_DRIVER_CLASS_NAME"
            value = "com.mysql.cj.jdbc.Driver"
          }
        env  {
            name  = "SPRING_JPA_HIBERNATE_DDL_AUTO"
            value = "update"
          }
        env  {
            name  = "SPRING_JPA_SHOW_SQL"
            value = "true"
          }
        env  {
            name  = "SPRING_JPA_PROPERTIES_HIBERNATE_DIALECT"
            value = "org.hibernate.dialect.MySQLDialect"
          }
        ports {
          container_port = 8080
        }
      }
  }
}