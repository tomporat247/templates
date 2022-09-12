terraform {
  backend "remote" {
    hostname = "backend-dev.api.dev.env0.com"
    organization = "737bb6df-1d96-4cec-825b-1e957dc54b95"

    workspaces {
      name = "qa"
    }
  }

  required_version = "= 1.2.3"
}