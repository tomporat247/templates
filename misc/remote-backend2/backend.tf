terraform {
  backend "remote" {
    organization = "tomporat247"
    workspaces {
      name = "templates3"
    }
  }

  required_version = "= 1.2.3"
}