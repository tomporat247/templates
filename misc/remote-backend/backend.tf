terraform {
  backend "remote" {
    hostname = "https://app.terraform.io/"
    organization = "tomporat247"
    workspaces {
      name = "templates"
    }
  }
}