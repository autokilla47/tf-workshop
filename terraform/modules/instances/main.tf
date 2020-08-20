resource "google_compute_instance" "instances" {
  count           = var.vmCount
  machine_type    = "g1-small"
  zone            = var.zone
  name            = "${var.name}-${count.index}"
  tags            = ["workshop"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
      size = 10
    }
  }

  network_interface {
    network = "default"
    access_config {
      network_tier = "PREMIUM"
    }
  }

  metadata = {
    ssh-keys = "deploy:${var.ssh_pub_key}"
  }
}

output "ip" {
  value = google_compute_instance.instances.*.network_interface.0.access_config.0.nat_ip
}