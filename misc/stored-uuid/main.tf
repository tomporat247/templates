variable "env_customer_id" {
  type    = string
  default = ""
}

resource "random_uuid" "generated_id" { }

output "env_customer_id" {
  value = trimspace(var.env_customer_id) != "" ? var.env_customer_id : random_uuid.generated_id.result
}
