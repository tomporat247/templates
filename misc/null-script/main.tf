resource "null_resource" "null2" {
}

moved {
  from = null_resource.null
  to   = null_resource.null2
}
