# LAN-PRD
resource "openstack_networking_network_v2" "lan-prd" {
  name = var.lan-prd-name
}

resource "openstack_networking_subnet_v2" "sub_lan-prd" {
  name       = var.lan-prd_subnet-name
  network_id = openstack_networking_network_v2.lan-prd.id
  cidr       = var.lan-prd-net
  ip_version = 4
  no_gateway = "true"

  enable_dhcp = "true"

  allocation_pool {
    start = cidrhost(var.lan-prd-net, 10)
    end   = cidrhost(var.lan-prd-net, 200)
  }

  dns_nameservers = [cidrhost(var.lan-prd-net, 1), cidrhost(var.lan-prd-net, 4), cidrhost(var.lan-prd-net, 5)]
}

resource "openstack_networking_subnet_route_v2" "sub_lan-prd_route_1" {
  subnet_id        = openstack_networking_subnet_v2.sub_lan-prd.id
  destination_cidr = "0.0.0.0/0"
  next_hop         = cidrhost(var.lan-prd-net, 1)
}

# LAN-ORA
resource "openstack_networking_network_v2" "lan-ora" {
  name = var.lan-ora-name
  
#  segments {
#    physical_network = "external"
#    segmentation_id  = 2888
#    network_type     = "vlan"
#  }
}

resource "openstack_networking_subnet_v2" "sub_lan-ora" {
  name       = var.lan-ora_subnet-name
  network_id = openstack_networking_network_v2.lan-ora.id
  cidr       = var.lan-ora-net
  ip_version = 4
  no_gateway = "true"

  enable_dhcp = "true"

  allocation_pool {
    start = cidrhost(var.lan-ora-net, 200)
    end   = cidrhost(var.lan-ora-net, 250)
  }

#  dns_nameservers = [cidrhost(var.lan-ora-net, 1), cidrhost(var.lan-ora-net, 4), cidrhost(var.lan-ora-net, 5)]
}

#resource "openstack_networking_subnet_route_v2" "sub_lan-ora_route_1" {
#  subnet_id        = openstack_networking_subnet_v2.sub_lan-ora.id
#  destination_cidr = "0.0.0.0/0"
#  next_hop         = cidrhost(var.lan-ora-net, 1)
#}

# LAN-DEV
resource "openstack_networking_network_v2" "lan-dev" {
  name = var.lan-dev-name
}

resource "openstack_networking_subnet_v2" "sub_lan-dev" {
  name       = var.lan-dev_subnet-name
  network_id = openstack_networking_network_v2.lan-dev.id
  cidr       = var.lan-dev-net
  ip_version = 4
  no_gateway = "true"

  enable_dhcp = "true"

  allocation_pool {
    start = cidrhost(var.lan-dev-net, 10)
    end   = cidrhost(var.lan-dev-net, 200)
  }

  dns_nameservers = [cidrhost(var.lan-dev-net, 1), cidrhost(var.lan-dev-net, 4), cidrhost(var.lan-dev-net, 5)]
}

resource "openstack_networking_subnet_route_v2" "sub_lan-dev_route_1" {
  subnet_id        = openstack_networking_subnet_v2.sub_lan-dev.id
  destination_cidr = "0.0.0.0/0"
  next_hop         = cidrhost(var.lan-dev-net, 1)
}

# LAN-STG
resource "openstack_networking_network_v2" "lan-stg" {
  name = var.lan-stg-name
}

resource "openstack_networking_subnet_v2" "sub_lan-stg" {
  name       = var.lan-stg_subnet-name
  network_id = openstack_networking_network_v2.lan-stg.id
  cidr       = var.lan-stg-net
  ip_version = 4
  no_gateway = "true"

  enable_dhcp = "true"

  allocation_pool {
    start = cidrhost(var.lan-stg-net, 10)
    end   = cidrhost(var.lan-stg-net, 200)
  }

  dns_nameservers = [cidrhost(var.lan-stg-net, 1), cidrhost(var.lan-stg-net, 4), cidrhost(var.lan-stg-net, 5)]
}

resource "openstack_networking_subnet_route_v2" "sub_lan-stg_route_1" {
  subnet_id        = openstack_networking_subnet_v2.sub_lan-stg.id
  destination_cidr = "0.0.0.0/0"
  next_hop         = cidrhost(var.lan-stg-net, 1)
}

# HA
resource "openstack_networking_network_v2" "ha" {
  name = var.ha-name
}

resource "openstack_networking_subnet_v2" "sub_ha" {
  name       = var.ha_subnet-name
  network_id = openstack_networking_network_v2.ha.id
  cidr       = var.ha-net
  ip_version = 4
}

# WAN
resource "openstack_networking_network_v2" "wan" {
  name = var.wan-name
}

resource "openstack_networking_subnet_v2" "sub_wan" {
  name       = var.wan_subnet-name
  network_id = openstack_networking_network_v2.wan.id
  cidr       = var.wan-net
  gateway_ip = cidrhost(var.wan-net, 1)
  ip_version = 4

  enable_dhcp = "true"

  allocation_pool {
    start = cidrhost(var.wan-net, 200)
    end   = cidrhost(var.wan-net, 254)
  }

  dns_nameservers = ["8.8.8.8", "1.1.1.1", "8.8.4.4"]
}

## Routers
# Internet
resource "openstack_networking_router_v2" "router_internet" {
  name                = "router_internet"
  external_network_id = var.PublicNet
  distributed         = "false"

  value_specs = {
    ha = "true"
  }
}

resource "openstack_networking_router_interface_v2" "router_interface_wan" {
  router_id = openstack_networking_router_v2.router_internet.id
  subnet_id = openstack_networking_subnet_v2.sub_wan.id
}
