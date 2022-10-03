terraform {
  backend "remote" {
    hostname = "backend-pr9583.api.dev.env0.com"
    organization = "ad49e112-8dbd-4407-b539-cc33038e3856.cb44262d-e872-413f-9155-f8ed22e9aec8"

    workspaces {
      prefix = "tom"
    }
  }
}
