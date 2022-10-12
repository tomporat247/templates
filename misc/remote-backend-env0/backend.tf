terraform {
  backend "remote" {
    hostname = "backend-dev.api.dev.env0.com"
    organization = "c2014ed1-c3b2-4ca9-b343-478e1f584fe0"

    workspaces {
      prefix = "demo-u"
    }
  }
}
