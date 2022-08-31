terraform {
  backend "remote" {
    hostname = "backend-pr9181.api.dev.env0.com"
    organization = "f7fac740-47c5-469d-9ec7-0fe52c8268a0"

    workspaces {
      name = "tom"
    }
  }
}