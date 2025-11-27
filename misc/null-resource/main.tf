resource "null_resource" "null" {
  count = 2

  triggers = {
      cluster_instance_ids = "123"
  }
}

output "null" {
  value = "output"
}
