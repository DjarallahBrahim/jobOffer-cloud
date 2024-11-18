# Changelog

## [1.2.0] - 2024-11-18
### Added
- Deployed Kafka on GCP with Docker containers using Terraform.
- Configured private DNS for internal communication between Kafka and other services (`kafka.service.jobstream`).
- Set up firewall rules to allow internal communication between Kafka, producer, consumer, and MySQL instances in the VPC.
- Configured internal and external listeners for Kafka (using DNS `kafka.service.jobstream` for internal communication).
- Configured Kafka environment variables for node ID, KRaft cluster ID, listeners, and controller quorum.
- Kafka instance set up with `bitnami/kafka` Docker image, running on a Google Compute Engine instance.
- Configured in-memory volume for Kafka container (can be changed to persistent storage).

### Changed
- Updated firewall rules to ensure secure communication between Kafka, producer, consumer, and Cloud SQL (MySQL).
- Adjusted internal DNS for Kafka communication to be accessible via `kafka.service.jobstream`.

## [1.1.0] - 2024-11-17
### Added
- **GCP Infrastructure Setup** for JobOffer application using **Terraform**.
- Configured a **VPC** with private and public subnets to host various services securely.
  - **Private Subnet** for Kafka, MySQL, and Compute Engine instances.
  - **Public Subnet** for Cloud Run services (React app, producer).
- **Firewall Rules** created for Kafka, MySQL, and React frontend services.
  - Kafka and producer services are allowed to communicate securely within the VPC.
  - MySQL communication restricted to Cloud SQL and Compute Engine instances only.
  - SSH access allowed for administrative purposes, with secure firewall restrictions.
  
### Changed
- Modularized Terraform configuration by separating **VPC** and **Firewall** settings into individual files (`vpc.tf`, `firewall.tf`) for maintainability.
- Updated to ensure infrastructure can scale easily, using distinct tags for service communication: `kafka-server`, `producer`, `consumer`, `mysql-db`, `cloud-run`.
  
### Next Steps (from both days)
- **Step 1**: Configure **Compute Engine Instances** for Kafka brokers and consumers.
- **Step 2**: Set up **Cloud SQL** for persistent MySQL storage.
- **Step 3**: Deploy **Cloud Run Services** for React app and producer.
  
## Conclusion
This version improves Kafka deployment with secure, internal DNS-based communication and updated firewall rules for service isolation. The infrastructure setup in GCP was modularized using Terraform, ensuring scalability and ease of future updates.