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

resource "google_secret_manager_secret" "example" {
  secret_id = var.secret_id

  labels = {
    label = "my-label"
  }

  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
      replicas {
        location = "us-east1"
      }
    }
  }
}

resource "google_secret_manager_secret_version" "example_version" {
  secret      = google_secret_manager_secret.example.id
  secret_data = var.secret_data
}
