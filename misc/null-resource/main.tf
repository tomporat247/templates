resource "null_resource" "null" {
  count = 3
}

output "null" {
  value = "output"
}