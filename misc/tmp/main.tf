terraform {
  required_providers {
    env0 = {
      source = "env0/env0"
    }
  }
}

# Configure the env0 provider

provider "env0" {
  api_key    = "tofkqoncrapb0tfu"
  api_secret = "AP_CnZ81YM_vkqxwtklKanWzPLYky55h"
}

data "env0_template" "template" {
  name = "null-variables"
}

data "env0_source_code_variables" "variables" {
  template_id = data.env0_template.template.id
}

output "variable_0_value" {
  value = data.env0_source_code_variables.variables.variables.0.value
}

output "variable_0_description" {
  value = data.env0_source_code_variables.variables.variables.0.description
}