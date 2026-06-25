data "template_file" "users" {
  template = file("cloud-init/ansiblegw_useradd.tpl")

  vars = {
    ansible_pub_cert = file("../.ssh/id_ed25519.pub")
  }
}

data "template_cloudinit_config" "cloudinit-users" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.users.rendered
  }
}

resource "openstack_networking_secgroup_v2" "secgroup_build" {
  name                 = "Cloud-Builder"
  description          = "Creazione e manutenzione del DataCenter via Cloud-Init e Ansible"
  delete_default_rules = true
}

# Always Allow communication with OpenStack ( required for cloud-init )
resource "openstack_networking_secgroup_rule_v2" "secgroup_build_rule_1" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "169.254.169.254/32"
  security_group_id = openstack_networking_secgroup_v2.secgroup_build.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_build_rule_2" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "${openstack_compute_instance_v2.instance_ansiblegw.network[1].fixed_ip_v4}/32"
  security_group_id = openstack_networking_secgroup_v2.secgroup_build.id
}

resource "openstack_networking_secgroup_v2" "secgroup_egress" {
  name                 = "Egress-Base"
  description          = "Permette tutto il traffico in uscita"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_egress_rule_1" {
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_egress.id
}

resource "openstack_networking_secgroup_v2" "secgroup_gestione" {
  name                 = "Gestione"
  description          = "Regole per la gestione dei Server"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_gestione_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_ip_prefix  = var.gestione-net
  security_group_id = openstack_networking_secgroup_v2.secgroup_gestione.id
}
