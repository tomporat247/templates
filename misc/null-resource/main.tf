resource "null_resource" "null" {
  count = 500000
}

terraform {
  backend "remote" {
    hostname = "backend-pr9807.api.dev.env0.com"
    organization = "c6bd2059-fc7f-4c52-b604-17f01fef7d76"

    workspaces {
      name = "many"
    }
  }
}