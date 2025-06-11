terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_cloud_run_service" "default" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      containers {
        image = var.image
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_policy" "all_users" {
  location    = google_cloud_run_service.default.location
  project     = var.project_id
  service     = google_cloud_run_service.default.name

  policy_data = jsonencode({
    "bindings" : [
      {
        "role" : "roles/run.invoker",
        "members" : ["allUsers"]
      }
    ]
  })
}
