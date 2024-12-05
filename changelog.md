# Changelog

# Changelog

## [2024-12-05] - Deployed GKE Cluster and Argo CD

### Added
- **GKE Cluster Deployment**
  - Deployed a GKE cluster using Terraform with the following configurations:
    - Private cluster in the `custom-vpc` network with dedicated subnets for services and pods.
    - Configured a node pool with `e2-standard-2` machine types, auto-upgrade, and auto-repair enabled.
    - Enabled network policies for enhanced pod communication security.
  - Integrated service account for the cluster with roles for Cloud SQL, Pub/Sub, and logging/monitoring.

- **Argo CD Deployment**
  - Installed Argo CD into the GKE cluster using Terraform and Helm.
  - Configured `argocd-server` service as a `LoadBalancer` type to allow external access.
  - Verified external connectivity and management through Argo CD's web UI.
  - Applied namespace isolation for Argo CD resources.

### Notes
- The GKE cluster was provisioned with sufficient pod and service IP ranges to avoid exhaustion.
- Argo CD external access required adjustments to the `Service` manifest for `argocd-server`.


### Added [2024-11-20] - Deployed a Kafka consumer

- **Kafka Consumer Deployment**
  - Deployed a Kafka consumer instance within the private network (`custom-vpc`).
  - Configured internal connectivity to Kafka and MySQL using private IPs.
  - Updated firewall rules:
    - Allowed traffic for Kafka and MySQL communication within the private network.
  - Verified end-to-end communication with Kafka and MySQL services.

### Notes
- The Kafka consumer instance was set up in the same private network as Kafka and MySQL for optimized performance and security.

## [2024-11-19] - Deploy MySQL Instance in Private Network

### Added
- Configured a **MySQL instance** on Google Cloud using Terraform.
- Enabled **private IP connectivity** for the MySQL instance to ensure secure access within the `custom-vpc` network.
- Reserved a global internal IP range for VPC peering using `google_compute_global_address` with `VPC_PEERING` purpose.
- Established a service networking connection between `custom-vpc` and Google-managed services for private connectivity.
- Set up the MySQL instance to use a private network for communication instead of public IP.
- Verified proper connectivity to the MySQL instance (`10.173.0.3`) via Kafka services deployed in the same VPC.

### Updated
- Updated `firewall` rules for `custom-vpc` to allow internal communication within the private subnet.

### Notes
- Private Service Access (PSA) was enabled for the `sql-subnet` to facilitate private connectivity.
- Public IP connectivity for the MySQL instance was explicitly disabled.
- Kafka and other services can now securely connect to the MySQL instance using its private IP.

## [2024-11-18] 
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

## [2024-11-17] 
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
