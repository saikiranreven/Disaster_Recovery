# PRIMARY LOAD BALANCER
resource "google_compute_global_address" "primary_ip" {
  name = "primary-lb-ip"
}

resource "google_compute_backend_bucket" "primary_backend" {
  name        = "primary-backend"
  bucket_name = google_storage_bucket.bucket_primary.name
  enable_cdn  = false
}

resource "google_compute_url_map" "primary_lb" {
  name            = "primary-lb"
  default_service = google_compute_backend_bucket.primary_backend.self_link
}

resource "google_compute_target_http_proxy" "primary_proxy" {
  name    = "primary-proxy"
  url_map = google_compute_url_map.primary_lb.self_link
}

resource "google_compute_global_forwarding_rule" "primary_http" {
  name       = "primary-http-lb"
  target     = google_compute_target_http_proxy.primary_proxy.self_link
  port_range = "80"
  ip_address = google_compute_global_address.primary_ip.address
}

# SECONDARY LOAD BALANCER
resource "google_compute_global_address" "secondary_ip" {
  name = "secondary-lb-ip"
}

resource "google_compute_backend_bucket" "secondary_backend" {
  name        = "secondary-backend"
  bucket_name = google_storage_bucket.bucket_secondary.name
  enable_cdn  = false
}

resource "google_compute_url_map" "secondary_lb" {
  name            = "secondary-lb"
  default_service = google_compute_backend_bucket.secondary_backend.self_link
}

resource "google_compute_target_http_proxy" "secondary_proxy" {
  name    = "secondary-proxy"
  url_map = google_compute_url_map.secondary_lb.self_link
}

resource "google_compute_global_forwarding_rule" "secondary_http" {
  name       = "secondary-http-lb"
  target     = google_compute_target_http_proxy.secondary_proxy.self_link
  port_range = "80"
  ip_address = google_compute_global_address.secondary_ip.address
}