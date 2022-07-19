terraform {
  backend "remote" {
    hostname = "tomporat247.scalr.io"
    organization = "env-u43jss4bbn4rsjg"
    workspaces {
      name = "templates2"
    }
  }
}