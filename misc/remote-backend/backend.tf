terraform {
  backend "remote" {
    organization = "tomporat247"
    workspaces {
      name = "templates"
    }
  }

  required_version = "= 1.2.3"
}