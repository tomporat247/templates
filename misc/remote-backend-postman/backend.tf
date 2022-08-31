terraform {
  backend "remote" {
    hostname = "f6f1c8c1-6e54-4d77-86f4-5b87cacfb2d2.mock.pstmn.io"
    organization = "env-u43jss4bbn4rsjg"
    workspaces {
      name = "templates"
    }
  }
}