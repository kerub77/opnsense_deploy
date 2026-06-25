output "firewall_public_ip" {
  value = openstack_networking_floatingip_v2.fip_1.address
}

output "public_ip_mapping" {
  value = zipmap(
    openstack_networking_floatingip_v2.additional_fip.*.address,
    openstack_networking_floatingip_v2.additional_fip.*.fixed_ip,
  )
}
