resource "null_resource" "null" {
  count = 2
}

terraform {
  required_version = "1.2.2"

  required_providers {
    null = {
      source = "hashicorp/null"
      version = "3.1.1"
    }
  }
}


provider "null" {
  version = "3.1.1"
}
