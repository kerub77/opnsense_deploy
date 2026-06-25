#terraform {
#  backend "consul" {
#    address = "127.0.0.1:8500"
#    path    = "${var.project_name}/terraform_state"
#    gzip    = true
#  }
#}
