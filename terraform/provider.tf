terraform {

  backend "gcs" {
  bucket = "dr-state-bucket"
  prefix = "terraform/state"
 }
}

provider "google" {
  project = var.project_id
  region  = var.primary_region
}

provider "google" {
  alias   = "secondary"
  project = var.project_id
  region  = var.secondary_region
}
