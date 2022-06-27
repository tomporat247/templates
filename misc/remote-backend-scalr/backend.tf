terraform {
  backend "remote" {
    hostname = "https://tomporat247.scalr.io/"
    organization = "tomporat247"
    workspaces {
      name = "templates"
    }
  }
}