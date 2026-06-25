data "template_file" "ansiblegwfile" {
  template = file("cloud-init/ansiblegw_write_files.yml")
}

data "template_file" "ansiblegwruncmd" {
  template = file("cloud-init/ansiblegw_runcmd.yml")
}

data "template_cloudinit_config" "cloudinit-ansiblegw" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.users.rendered
  }

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.ansiblegwfile.rendered
  }

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.ansiblegwruncmd.rendered
  }
}

resource "openstack_networking_secgroup_v2" "secgroup_ansiblegw" {
  name        = "Ansible_Gateway"
  description = "Gateway Ansible SSH"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_ansiblegw_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "${chomp(data.http.my_public_ip.body)}/32"
  security_group_id = openstack_networking_secgroup_v2.secgroup_ansiblegw.id
}

locals {
  security_group_ansiblegw = [
    openstack_networking_secgroup_v2.secgroup_ansiblegw.id,
    openstack_networking_secgroup_v2.secgroup_build.id,
    openstack_networking_secgroup_v2.secgroup_gestione.id,
  ]
}

## Network Port
resource "openstack_networking_port_v2" "ansiblegw_lan" {
  name           = "ansiblegw_lan"
  network_id     = openstack_networking_network_v2.lan-prd.id
  admin_state_up = "true"

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.sub_lan-prd.id
    ip_address = cidrhost(var.lan-prd-net, 6)
  }

  security_group_ids = local.security_group_ansiblegw
}

resource "openstack_networking_port_v2" "ansiblegw_wan" {
  name           = "ansiblegw_wan"
  network_id     = openstack_networking_network_v2.wan.id
  admin_state_up = "true"

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.sub_wan.id
    ip_address = cidrhost(var.wan-net, 6)
  }

  security_group_ids = local.security_group_ansiblegw
}

# ATTACH di un volume
resource "openstack_blockstorage_volume_v3" "volume_ansiblegw" {
  name                 = "volume_ansiblegw-boot"
  size                 = 8
  volume_type          = "Standard"
  image_id             = var.centos
  enable_online_resize = "false"
}

resource "openstack_compute_instance_v2" "instance_ansiblegw" {
  name        = "AnsibleGW.${var.project_domain}"
  flavor_name = "Small"
  region      = var.def_region

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.volume_ansiblegw.id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = "false"
  }

  network {
    port = openstack_networking_port_v2.ansiblegw_wan.id
  }

  network {
    port = openstack_networking_port_v2.ansiblegw_lan.id
  }

  user_data = data.template_cloudinit_config.cloudinit-ansiblegw.rendered
}

## Floating IP
resource "openstack_networking_floatingip_v2" "fip_2" {
  pool    = "Internet"
  port_id = openstack_networking_port_v2.ansiblegw_wan.id
}

data "http" "my_public_ip" {
  url = "https://ifconfig.io/ip"
}

data "template_file" "bastion_yaml" {
  template = file("../extras/bastion.tpl")

  vars = {
    bastion_ip = openstack_networking_floatingip_v2.fip_2.address
  }
}

resource "null_resource" "write_bastion" {
  triggers = {
    ansible_ip = openstack_networking_floatingip_v2.fip_2.address
  }

  provisioner "local-exec" {
    command = "echo \"${data.template_file.bastion_yaml.rendered}\" > ../ansible/envs/bastion.yml"
  }
}
