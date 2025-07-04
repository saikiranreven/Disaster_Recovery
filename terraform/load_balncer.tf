resource "google_compute_address" "lb_ip_primary" {
  name = "lb-ip-primary"
  # NO region attribute here means global IP
}

resource "google_compute_address" "lb_ip_secondary" {
  provider = google.secondary
  name     = "lb-ip-secondary"
  # NO region attribute here means global IP
}

# Backend buckets for static content serving (no health checks required)
resource "google_compute_backend_bucket" "primary_backend_bucket" {
  name        = "primary-backend-bucket"
  bucket_name = google_storage_bucket.bucket_primary.name
  enable_cdn  = false
}

resource "google_compute_backend_bucket" "secondary_backend_bucket" {
  provider    = google.secondary
  name        = "secondary-backend-bucket"
  bucket_name = google_storage_bucket.bucket_secondary.name
  enable_cdn  = false
}

# URL Maps pointing to backend buckets
resource "google_compute_url_map" "primary_url_map" {
  name            = "primary-url-map"
  default_service = google_compute_backend_bucket.primary_backend_bucket.id
}

resource "google_compute_url_map" "secondary_url_map" {
  provider        = google.secondary
  name            = "secondary-url-map"
  default_service = google_compute_backend_bucket.secondary_backend_bucket.id
}

# Target HTTP Proxies to route requests via URL maps
resource "google_compute_target_http_proxy" "primary_http_proxy" {
  name    = "primary-http-proxy"
  url_map = google_compute_url_map.primary_url_map.id
}

resource "google_compute_target_http_proxy" "secondary_http_proxy" {
  provider = google.secondary
  name     = "secondary-http-proxy"
  url_map  = google_compute_url_map.secondary_url_map.id
}

# Forwarding Rules to listen on reserved IPs and forward traffic
resource "google_compute_global_forwarding_rule" "primary_forwarding_rule" {
  name       = "primary-forwarding-rule"
  ip_address = google_compute_address.lb_ip_primary.address
  ip_protocol = "TCP"
  port_range  = "80"
  target     = google_compute_target_http_proxy.primary_http_proxy.id
}

resource "google_compute_global_forwarding_rule" "secondary_forwarding_rule" {
  provider    = google.secondary
  name        = "secondary-forwarding-rule"
  ip_address  = google_compute_address.lb_ip_secondary.address
  ip_protocol = "TCP"
  port_range  = "80"
  target      = google_compute_target_http_proxy.secondary_http_proxy.id
}
