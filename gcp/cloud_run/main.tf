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
}

resource "google_cloud_run_service" "default" {
  for_each = toset(var.regions)
  name     = var.service_name
  location = each.value

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
  for_each    = google_cloud_run_service.default
  location    = each.value.location
  project     = var.project_id
  service     = each.value.name

  policy_data = jsonencode({
    "bindings" : [
      {
        "role" : "roles/run.invoker",
        "members" : ["allUsers"]
      }
    ]
  })
}

resource "google_cloud_run_service_iam_member" "admin" {
  for_each = google_cloud_run_service.default
  location = each.value.location
  project  = each.value.project
  service  = each.value.name
  role     = "roles/run.admin"
  member   = "user:tom.porat@env0.com"
}
