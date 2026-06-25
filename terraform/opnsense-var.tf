# OPNsense HA image
variable "OPNsenseIMG" {
  default = "9ae949f2-0a25-4631-8605-0b37103344c2"
}

# OPNsense Disk Size
variable "OPNsenseDiskSize" {
  default = 16
}

variable "flavor_opnsense" {
  default = "Small"
}

variable "opnsense_storage_type" {
  default = "Prestazionale"
}

# OPNsense Additional Floating IP
variable "opnsense_additional_fip_count" {
  default = 1
}

# OPNsense Password
variable "opnsense_pass" {
  default = "opnsense"
}
