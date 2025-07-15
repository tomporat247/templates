terraform {
  required_providers {
    kafka = {
      source  = "Mongey/kafka"
      version = "0.10.3"
    }
  }
}

provider "kafka" {
  # Empty configuration - minimal setup for testing provider download
}
