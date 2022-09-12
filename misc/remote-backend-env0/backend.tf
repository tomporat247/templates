terraform {
  backend "remote" {
    hostname = "backend-pr9224.api.dev.env0.com"
    organization = "a24d5d61-8c2b-4a58-8917-9a663cf1c4c0"

    workspaces {
      name = "tom-qa"
    }
  }
}