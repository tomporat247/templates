provider "google" {
  project     = var.project
  region      = var.region
}

resource "google_storage_bucket" "static-site" {
  name          = var.bucket_name
  location      = var.bucket_location
  force_destroy = true

  uniform_bucket_level_access = true
}
