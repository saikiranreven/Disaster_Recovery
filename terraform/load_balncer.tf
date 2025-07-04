# Reserve static IPs
resource "google_compute_address" "lb_ip_primary" {
  name   = "lb-ip-primary"
  region = var.primary_region
}

resource "google_compute_address" "lb_ip_secondary" {
  provider = google.secondary
  name     = "lb-ip-secondary"
  region   = var.secondary_region
}

# Minimal backend service (no instances needed, just placeholder)
resource "google_compute_backend_service" "primary_backend" {
  name                            = "primary-backend"
  protocol                        = "HTTP"
  load_balancing_scheme           = "EXTERNAL_MANAGED"
  timeout_sec                     = 10
  health_checks                   = []
}

resource "google_compute_backend_service" "secondary_backend" {
  provider                        = google.secondary
  name                            = "secondary-backend"
  protocol                        = "HTTP"
  load_balancing_scheme           = "EXTERNAL_MANAGED"
  timeout_sec                     = 10
  health_checks                   = []
}

# URL Map
resource "google_compute_url_map" "primary_url_map" {
  name            = "primary-url-map"
  default_service = google_compute_backend_service.primary_backend.id
}

resource "google_compute_url_map" "secondary_url_map" {
  provider        = google.secondary
  name            = "secondary-url-map"
  default_service = google_compute_backend_service.secondary_backend.id
}

# Target HTTP Proxy
resource "google_compute_target_http_proxy" "primary_proxy" {
  name   = "primary-http-proxy"
  url_map = google_compute_url_map.primary_url_map.id
}

resource "google_compute_target_http_proxy" "secondary_proxy" {
  provider = google.secondary
  name     = "secondary-http-proxy"
  url_map  = google_compute_url_map.secondary_url_map.id
}

# Forwarding Rule
resource "google_compute_global_forwarding_rule" "primary_forwarding_rule" {
  name       = "primary-forwarding-rule"
  ip_address = google_compute_address.lb_ip_primary.address
  port_range = "80"
  target     = google_compute_target_http_proxy.primary_proxy.id
}

resource "google_compute_global_forwarding_rule" "secondary_forwarding_rule" {
  provider   = google.secondary
  name       = "secondary-forwarding-rule"
  ip_address = google_compute_address.lb_ip_secondary.address
  port_range = "80"
  target     = google_compute_target_http_proxy.secondary_proxy.id
}