terraform {
  backend "remote" {
    hostname = "tomporat247.scalr.io"
    organization = "env-u43jss4bbn4rsjg" # TODO: add project, should probably be a JSON
    workspaces {
      name = "test1"
    }
  }
}