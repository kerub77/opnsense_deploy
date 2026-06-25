
terraform {
  required_version = ">= 0.13"
  required_providers {
    http = {
      source = "hashicorp/http"
    }
    null = {
      source = "hashicorp/null"
    }
    openstack = {
      source = "terraform-providers/openstack"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}
