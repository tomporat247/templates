provider "random" {}


resource "random_integer" "time" {
  min = 1
  max = 10
}


resource "null_resource" "null" {
  depends_on = [time_sleep.wait]
}

resource "time_sleep" "wait" {
  create_duration = "${random_integer.time.result}s"
}

output "x" {
  value = "y"
}
