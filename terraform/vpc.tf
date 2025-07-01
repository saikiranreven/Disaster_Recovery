resource "google_compute_network" "vpc_primary" {
  name                    = "vpc-primary"
  auto_create_subnetworks = false
}

resource "google_compute_network" "vpc_secondary" {
  provider                = google.secondary
  name                    = "vpc-secondary"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_primary" {
  name          = "subnet-primary"
  ip_cidr_range = "10.10.0.0/24"
  region        = var.primary_region
  network       = google_compute_network.vpc_primary.id
}

resource "google_compute_subnetwork" "subnet_secondary" {
  provider      = google.secondary
  name          = "subnet-secondary"
  ip_cidr_range = "10.20.0.0/24"
  region        = var.secondary_region
  network       = google_compute_network.vpc_secondary.id
}