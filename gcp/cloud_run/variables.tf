variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "env0project"
}

variable "regions" {
  description = "The GCP regions to deploy the service to"
  type        = list(string)
  default     = ["us-central1", "europe-west1"]
}

variable "service_name" {
  description = "The base name of the Cloud Run service"
  type        = string
  default     = "tom-test-service"
}

variable "image" {
  description = "The container image to deploy"
  type        = string
  default     = "gcr.io/cloudrun/hello"
}
