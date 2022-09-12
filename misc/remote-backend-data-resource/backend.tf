data "terraform_remote_state" "xxx" {
  backend = "remote"

  config = {
    organization = "tomporat247"
    workspaces = {
      name = "templates"
    }
  }
}