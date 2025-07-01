resource "google_storage_bucket" "bucket_primary" {
  name          = "primary-bucket-project-bct-463501"
  location      = var.primary_region
  force_destroy = true

  versioning {
    enabled = true
  }
}

resource "google_storage_bucket" "bucket_secondary" {
  name          = "secondary-bucket-project-bct-463501"
  location      = var.secondary_region
  force_destroy = true

  versioning {
    enabled = true
  }
}