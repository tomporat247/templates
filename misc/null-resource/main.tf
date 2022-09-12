terraform {
  required_version = "1.2.2"

  required_providers {
    null = "3.1.1"
  }
}


provider "null" {
}

resource "null_resource" "null" {
  count = 2
}