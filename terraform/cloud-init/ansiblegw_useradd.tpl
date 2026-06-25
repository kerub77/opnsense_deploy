---

users:
- name: ansible
  ssh-authorized-keys:
  - ${ansible_pub_cert}
  sudo: ['ALL=(ALL) NOPASSWD:ALL']
