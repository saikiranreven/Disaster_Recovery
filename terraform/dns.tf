resource "google_dns_managed_zone" "dr_zone" {
  name     = "dr-zone"
  dns_name = var.dns_domain
}

resource "google_dns_record_set" "primary_record" {
  name         = "app.${var.dns_domain}"
  type         = "A"
  ttl          = 60
  managed_zone = google_dns_managed_zone.dr_zone.name
  rrdatas      = [google_compute_global_address.primary_ip.address]  # Updated
}

resource "google_dns_record_set" "failover_record" {
  name         = "failover.${var.dns_domain}"
  type         = "A"
  ttl          = 60
  managed_zone = google_dns_managed_zone.dr_zone.name
  rrdatas      = [google_compute_global_address.secondary_ip.address]  # Updated
}