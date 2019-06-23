
resource "google_compute_network" "cot_net" {
  name       = "cot-net"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}

resource "google_compute_firewall" "allow_internal" {
  name    = "cot-fw-allow-internal"
  network = "${google_compute_network.cot_net.name}"
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  source_ranges = [
    "${var.cot_private_subnet}",
    "${var.cot_public_subnet}"
  ]
}

resource "google_compute_firewall" "allow-http" {
  name    = "cot-fw-allow-http"
  network = "${google_compute_network.cot_net.name}"
  
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags = ["http"] 
}

resource "google_compute_firewall" "allow-ssh" {
  name    = "cot-fw-allow-ssh"
  network = "${google_compute_network.cot_net.name}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["ssh"]
}

resource "google_compute_subnetwork" "cot_pub_net" {
  name          =  "cot-pub-net"
  ip_cidr_range = "${var.cot_public_subnet}"
  network       = "${google_compute_network.cot_net.name}"
  region        = "${var.region}"
}

resource "google_compute_subnetwork" "cot_priv_net" {
  name          =  "cot-priv-net"
  ip_cidr_range = "${var.cot_private_subnet}"
  network       = "${google_compute_network.cot_net.name}"
  region        = "${var.region}"
}