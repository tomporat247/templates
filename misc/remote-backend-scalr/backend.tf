terraform {
  backend "remote" {
    hostname = "https://scalr.io/"
    organization = "tomporat247"
    workspaces {
      name = "templates"
    }
  }
}