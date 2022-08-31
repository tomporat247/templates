terraform {
  required_providers {
    env0 = {
      source = "env0/env0"
    }
  }
}

# Configure the env0 provider

provider "env0" {
  api_key    = "kktgiontrgf7uy69"
  api_secret = "M_-oK8vGAA3ecKALkJh3SiBt0wbliJmX"
  api_endpoint = "https://api-dev.dev.env0.com"
}

data "env0_source_code_variables" "variables" {
  template_id = "8ce31d6c-1bb3-4881-97f8-8ba4c90772e6"
}

output "variable_0_value" {
  value = data.env0_source_code_variables.variables.variables.0.value
}

output "variable_0" {
  value = data.env0_source_code_variables.variables.variables.0
}