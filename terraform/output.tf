output "primary_bucket_url" {
  value = google_storage_bucket.bucket_primary.url
}

output "secondary_bucket_url" {
  value = google_storage_bucket.bucket_secondary.url
}

output "dns_zone_name" {
  value = google_dns_managed_zone.dr_zone.dns_name
}