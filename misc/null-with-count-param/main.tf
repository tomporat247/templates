resource "null_resource" "null" {
  count = var.count_param
}

output "null" {
  value = "output"
}
