resource "google_compute_instance" "gitalb-ci-runner" {
  name                      = "gitlab-ci-runner"
  hostname                  = var.hostname
  machine_type              = var.ci_runner_instance_type
  project                   = var.gcp_project
  zone                      = var.gcp_zone

  scheduling {
    preemptible       = true
    automatic_restart = false
  }

  boot_disk {
    initialize_params {
      image = "rocky-linux-cloud/rocky-linux-8"
      size  = 20
      type  = "pd-standard"
    }
  }
  network_interface {
    network = "default"
    access_config {
      // Include this section to give the VM an external ip address
    }
  }
  labels = {
    environment = "dev"
  }

  metadata = {
    enable-oslogin = "TRUE"
  }
}

data "google_client_openid_userinfo" "me" {
}

resource "google_os_login_ssh_public_key" "add_my_key" {
  project = var.gcp_project
  user =  data.google_client_openid_userinfo.me.email
  key = file("~/.ssh/id_ed25519.pub")
}

resource "google_service_account" "service_account" {
  account_id   = "ansible"
  display_name = "ansible"
}
resource "google_service_account_key" "service_account" {
  service_account_id = google_service_account.service_account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}
resource "local_file" "service_account" {
    content  = base64decode(google_service_account_key.service_account.private_key)
    filename = "./service_account.json"
}

resource "google_project_iam_binding" "project" {
  project = var.gcp_project
  role    = "roles/viewer"

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}