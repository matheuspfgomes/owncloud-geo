variable "zone" 	     { default = "us-east1-b" }
variable "tags" 	     { default = ["owncloud"] }
variable "image" 	     { default = "debian-9-stretch-v20180716" }
variable "machine_type"      { default = "n1-standard-2" }

resource "google_compute_instance" "owncloud" {
    count = "${length(var.tags)}"
    name = "owncloud-${count.index+1}"
    machine_type = "${var.machine_type}"
    zone = "${var.zone}"
    tags = ["${var.tags[count.index]}"]

    boot_disk = {
      initialize_params {
        image = "${var.image}"
    }
  }

    network_interface {
      network = "default"
      access_config {
      }
    }
}

resource "google_compute_address" "owncloud" {
    name = "tf-owncloud-address"
}

resource "google_compute_target_pool" "owncloud" {
  name = "tf-owncloud-target-pool"
  instances = ["${google_compute_instance.owncloud.*.self_link}"]
  health_checks = ["${google_compute_http_health_check.http.name}"]
}

resource "google_compute_forwarding_rule" "http" {
  name = "tf-owncloud-http-forwarding-rule"
  target = "${google_compute_target_pool.owncloud.self_link}"
  ip_address = "${google_compute_address.owncloud.address}"
  port_range = "80"
}

resource "google_compute_forwarding_rule" "https" {
  name = "tf-owncloud-https-forwarding-rule"
  target = "${google_compute_target_pool.owncloud.self_link}"
  ip_address = "${google_compute_address.owncloud.address}"
  port_range = "443"
}

resource "google_compute_http_health_check" "http" {
  name = "tf-owncloud-http-basic-check"
  request_path = "/"
  check_interval_sec = 5 
  healthy_threshold = 1
  unhealthy_threshold = 10
  timeout_sec = 2
}

resource "google_compute_firewall" "owncloud" {
  name = "tf-owncloud-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["owncloud"]
}
output "ip_publico" {
  value = "${google_compute_instance.owncloud.network_interface.0.access_config.0.assigned_nat_ip}"
}
