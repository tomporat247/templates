resource "null_resource" "null" {
  count = 2
}

output "null" {
  value = "output"
}