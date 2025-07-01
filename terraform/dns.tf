resource "google_dns_managed_zone" "dr_zone" {
  name     = "dr-zone"
  dns_name = var.dns_domain
}

resource "google_dns_record_set" "primary_record" {
  name         = "app.${var.dns_domain}"
  type         = "A"
  ttl          = 60
  managed_zone = google_dns_managed_zone.dr_zone.name
  rrdatas      = ["1.2.3.4"]
}

resource "google_dns_record_set" "secondary_record" {
  name         = "failover.${var.dns_domain}"
  type         = "A"
  ttl          = 60
  managed_zone = google_dns_managed_zone.dr_zone.name
  rrdatas      = ["5.6.7.8"]
}