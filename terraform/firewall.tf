# PRIMARY REGION FIREWALL RULES
resource "google_compute_firewall" "allow_http_primary" {
  name    = "allow-http-primary"
  network = google_compute_network.vpc_primary.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  priority      = 1000
}

resource "google_compute_firewall" "allow_ssh_primary" {
  name    = "allow-ssh-primary"
  network = google_compute_network.vpc_primary.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  priority      = 1000
}

# SECONDARY REGION FIREWALL RULES
resource "google_compute_firewall" "allow_http_secondary" {
  provider = google.secondary
  name     = "allow-http-secondary"
  network  = google_compute_network.vpc_secondary.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  priority      = 1000
}

resource "google_compute_firewall" "allow_ssh_secondary" {
  provider = google.secondary
  name     = "allow-ssh-secondary"
  network  = google_compute_network.vpc_secondary.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  priority      = 1000
}