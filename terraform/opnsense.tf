## Anti Affinity Group
resource "openstack_compute_servergroup_v2" "group_opnsense" {
  name     = "group_opnsense"
  policies = ["anti-affinity"]
}

## Network Port
resource "openstack_networking_port_v2" "port_opnsense_wan" {
  name               = "port_opnsense_${count.index == 0 ? "master" : "backup"}_wan"
  count              = 2
  network_id         = openstack_networking_network_v2.wan.id
  admin_state_up     = "true"
  no_security_groups = "true"

  value_specs = {
    port_security_enabled = "false"
  }

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.sub_wan.id
    ip_address = cidrhost(var.wan-net, 4 + count.index)
  }
}

# LAN-PRD
resource "openstack_networking_port_v2" "port_opnsense_lan-prd" {
  name               = "port_opnsense_${count.index == 0 ? "master" : "backup"}_lan-prd"
  count              = 2
  network_id         = openstack_networking_network_v2.lan-prd.id
  admin_state_up     = "true"
  no_security_groups = "true"

  value_specs = {
    port_security_enabled = "false"
  }

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.sub_lan-prd.id
    ip_address = cidrhost(var.lan-prd-net, 4 + count.index)
  }
}

# LAN-DEV
resource "openstack_networking_port_v2" "port_opnsense_lan-dev" {
  name               = "port_opnsense_${count.index == 0 ? "master" : "backup"}_lan-dev"
  count              = 2
  network_id         = openstack_networking_network_v2.lan-dev.id
  admin_state_up     = "true"
  no_security_groups = "true"

  value_specs = {
    port_security_enabled = "false"
  }

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.sub_lan-dev.id
    ip_address = cidrhost(var.lan-dev-net, 4 + count.index)
  }
}

# LAN-STG
resource "openstack_networking_port_v2" "port_opnsense_lan-stg" {
  name               = "port_opnsense_${count.index == 0 ? "master" : "backup"}_lan-stg"
  count              = 2
  network_id         = openstack_networking_network_v2.lan-stg.id
  admin_state_up     = "true"
  no_security_groups = "true"

  value_specs = {
    port_security_enabled = "false"
  }

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.sub_lan-stg.id
    ip_address = cidrhost(var.lan-stg-net, 4 + count.index)
  }
}

# LAN-ORA
resource "openstack_networking_port_v2" "port_opnsense_lan-ora" {
  name               = "port_opnsense_${count.index == 0 ? "master" : "backup"}_lan-ora"
  count              = 2
  network_id         = openstack_networking_network_v2.lan-ora.id
  admin_state_up     = "true"
  no_security_groups = "true"

  value_specs = {
    port_security_enabled = "false"
  }

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.sub_lan-ora.id
    ip_address = cidrhost(var.lan-ora-net, 4 + count.index)
  }
}

resource "openstack_networking_port_v2" "port_opnsense_ha" {
  name               = "port_opnsense_${count.index == 0 ? "master" : "backup"}_ha"
  count              = 2
  network_id         = openstack_networking_network_v2.ha.id
  admin_state_up     = "true"
  no_security_groups = "true"

  value_specs = {
    port_security_enabled = "false"
  }

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.sub_ha.id
    ip_address = cidrhost(var.ha-net, 4 + count.index)
  }
}

# Boot volume
resource "openstack_blockstorage_volume_v3" "volume_opnsense" {
  name                 = "volume_opnsense_boot_${count.index == 0 ? "master" : "backup"}"
  count                = 2
  size                 = var.OPNsenseDiskSize
  volume_type          = var.opnsense_storage_type
  image_id             = var.OPNsenseIMG
  enable_online_resize = "false"
}

## OPNsense Appliances
resource "openstack_compute_instance_v2" "instance_opnsense" {
  name        = "OPNsenseHA-${count.index == 0 ? "Master" : "Backup"}.${var.project_domain}"
  count       = 2
  flavor_name = var.flavor_opnsense
  region      = var.def_region

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.volume_opnsense[count.index].id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = "false"
  }

  network {
    port = openstack_networking_port_v2.port_opnsense_wan[count.index].id
  }

  network {
    port = openstack_networking_port_v2.port_opnsense_lan-prd[count.index].id
  }
  
  network {
    port = openstack_networking_port_v2.port_opnsense_ha[count.index].id
  }

  network {
    port = openstack_networking_port_v2.port_opnsense_lan-dev[count.index].id
  }

  network {
    port = openstack_networking_port_v2.port_opnsense_lan-stg[count.index].id
  }

  network {
    port = openstack_networking_port_v2.port_opnsense_lan-ora[count.index].id
  }
  
  scheduler_hints {
    group = openstack_compute_servergroup_v2.group_opnsense.id
  }
}

## Network Port VIP
resource "openstack_networking_port_v2" "opnsense_lan_vip" {
  name               = "opnsense_lan_vip"
  network_id         = openstack_networking_network_v2.lan-prd.id
  admin_state_up     = "true"
  no_security_groups = "true"

  value_specs = {
    port_security_enabled = "false"
  }

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.sub_lan-prd.id
    ip_address = cidrhost(var.lan-prd-net, 1)
  }
}

resource "openstack_networking_port_v2" "port_opnsense_wan_vip" {
  name               = "port_opnsense_wan_vip"
  network_id         = openstack_networking_network_v2.wan.id
  admin_state_up     = "true"
  no_security_groups = "true"

  value_specs = {
    port_security_enabled = "false"
  }

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.sub_wan.id
    ip_address = cidrhost(var.wan-net, 100)
  }
}

## Firewall Floating IP
resource "openstack_networking_floatingip_v2" "fip_1" {
  pool    = "Internet"
  port_id = openstack_networking_port_v2.port_opnsense_wan_vip.id
}

resource "openstack_networking_port_v2" "port_opnsense_wan_vip_additional" {
  count              = var.opnsense_additional_fip_count
  name               = "port_opnsense_wan_vip_additional_${format("%d", count.index + 1)}"
  network_id         = openstack_networking_network_v2.wan.id
  admin_state_up     = "true"
  no_security_groups = "true"

  value_specs = {
    port_security_enabled = "false"
  }

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.sub_wan.id
    ip_address = cidrhost(var.wan-net, 100 + count.index + 1)
  }
}

## Additional Floating IP
resource "openstack_networking_floatingip_v2" "additional_fip" {
  count   = var.opnsense_additional_fip_count
  pool    = "Internet"
  port_id = openstack_networking_port_v2.port_opnsense_wan_vip_additional[count.index].id
}

resource "null_resource" "resize_disk" {
  count = 2

  depends_on = [
    openstack_compute_instance_v2.instance_opnsense,
    openstack_compute_instance_v2.instance_ansiblegw,
  ]

  triggers = {
    opnsense_vol = openstack_blockstorage_volume_v3.volume_opnsense[count.index].id
  }

  provisioner "remote-exec" {
    inline = [
      "gpart recover /dev/da0",
      "gpart resize -i 3 -a 4k da0",
      "growfs -y /dev/gpt/rootfs",
    ]

    connection {
      type                = "ssh"
      host                = openstack_networking_port_v2.port_opnsense_lan-prd.*.fixed_ip.0.ip_address[count.index]
      user                = "root"
      password            = var.opnsense_pass
      bastion_host        = openstack_networking_floatingip_v2.fip_2.address
      bastion_user        = "ansible"
      bastion_private_key = file("../.ssh/id_ed25519")
    }
  }
}

resource "null_resource" "push_config" {
  count = 2

  depends_on = [
    openstack_compute_instance_v2.instance_opnsense,
    openstack_compute_instance_v2.instance_ansiblegw,
  ]

  triggers = {
    opnsense_vol = openstack_blockstorage_volume_v3.volume_opnsense[count.index].id
    policy_sha1 = filesha1(
      "./opnsense/config-OPNsense-${count.index == 0 ? "Master" : "Backup"}.xml",
    )
  }

  provisioner "file" {
    source      = "./opnsense/config-OPNsense-${count.index == 0 ? "Master" : "Backup"}.xml"
    destination = "/conf/config.xml"

    connection {
      type                = "ssh"
      host                = openstack_networking_port_v2.port_opnsense_lan-prd.*.fixed_ip.0.ip_address[count.index]
      user                = "root"
      password            = var.opnsense_pass
      bastion_host        = openstack_networking_floatingip_v2.fip_2.address
      bastion_user        = "ansible"
      bastion_private_key = file("../.ssh/id_ed25519")
    }
  }
}

resource "null_resource" "reboot" {
  count = 2

  depends_on = [
    openstack_compute_instance_v2.instance_opnsense,
    openstack_compute_instance_v2.instance_ansiblegw,
  ]

  triggers = {
    reboot_trigger_1 = null_resource.push_config[count.index].id
    reboot_trigger_2 = null_resource.resize_disk[count.index].id
  }

  provisioner "remote-exec" {
    inline = [
      "shutdown -o -r -n +1 && exit",
    ]

    connection {
      type                = "ssh"
      host                = openstack_networking_port_v2.port_opnsense_lan-prd.*.fixed_ip.0.ip_address[count.index]
      user                = "root"
      password            = var.opnsense_pass
      bastion_host        = openstack_networking_floatingip_v2.fip_2.address
      bastion_user        = "ansible"
      bastion_private_key = file("../.ssh/id_ed25519")
    }
  }
}

data "template_file" "openvpn_cfg" {
  template = file("../extras/OpenVPN.tpl")

  vars = {
    public_ip = openstack_networking_floatingip_v2.fip_1.address
  }
}

resource "null_resource" "write_cfg" {
  triggers = {
    firewall_ip = openstack_networking_floatingip_v2.fip_1.address
  }

  provisioner "local-exec" {
    command = "echo \"${data.template_file.openvpn_cfg.rendered}\" > ../openvpn.ovpn"
  }
}
