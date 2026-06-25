# Openstack default region
variable "def_region" {
  default = "RegionTwo"
}

# Project Name
variable "project_name" {
  default = "Test_Mario"
}

# DNS Domain (domain suffix to append to the instance name)
variable "project_domain" {
  default = "cloudspc"
}

# CentOS 8 image
variable "centos" {
  default = "158ce14d-e10b-4a59-8727-5c49451a1408"
}

# CentOS Boot Volume Size
variable "CentOSDiskSize" {
  default = "16"
}

# Public Network
variable "PublicNet" {
  default = "b01c4b9e-26b8-41b0-a12f-2f5fdab84e70"
}

# WAN
variable "wan-name" {
  default = "wan-net"
}

variable "wan_subnet-name" {
  default = "wan-subnet"
}

variable "wan-net" {
  default = "172.16.255.0/24"
}

# LAN-PRD
variable "lan-prd-name" {
  default = "lan-prd"
}

variable "lan-prd_subnet-name" {
  default = "lan-subnet-prd"
}

variable "lan-prd-net" {
  default = "10.150.100.0/24"
}

# LAN-DEV
variable "lan-dev-name" {
  default = "lan-dev"
}

variable "lan-dev_subnet-name" {
  default = "lan-subnet-dev"
}

variable "lan-dev-net" {
  default = "10.151.100.0/24"
}

# LAN-STG
variable "lan-stg-name" {
  default = "lan-stg"
}

variable "lan-stg_subnet-name" {
  default = "lan-subnet-stg"
}

variable "lan-stg-net" {
  default = "10.152.100.0/24"
}

# HA
variable "ha-name" {
  default = "ha-net"
}

variable "ha_subnet-name" {
  default = "ha-subnet"
}

variable "ha-net" {
  default = "192.168.255.0/24"
}

# LAN-ORA
variable "lan-ora-name" {
  default = "lan-ora"
}

variable "lan-ora_subnet-name" {
  default = "lan-subnet-ora"
}

variable "lan-ora-net" {
  default = "192.168.80.0/24"
}

# OpenVPN Gestione
variable "gestione-net" {
  default = "10.0.16.0/24"
}
