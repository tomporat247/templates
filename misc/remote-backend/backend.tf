terraform {
  backend "remote" {
    organization = "tomporat247"
    workspaces {
      name = "templates"
    }
  }
}