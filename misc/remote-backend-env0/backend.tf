terraform {
  backend "remote" {
    hostname = "backend-pr9181.api.dev.env0.com"
    organization = "66d0f339-1ac0-409f-a78b-984272a4a661"

    workspaces {
      name = "tom"
    }
  }
}