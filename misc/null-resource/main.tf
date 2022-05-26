provider "random" {}


resource "random_integer" "time" {
  min = 1
  max = 10
}


resource "null_resource" "null" {
  depends_on = [time_sleep.wait_30_seconds]
}

resource "time_sleep" "wait" {
  depends_on = [null_resource.previous]

  create_duration = "${random_integer.time.result}s"
}
