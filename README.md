### Base Stack using Terraform and Ansible on Cloud SPC

#### Requirements:
* python >= 2.6
* [Terraform](https://www.terraform.io/)
* [Ansible](https://www.ansible.com/)

#### Usage
```
$ make
install                        Install required software (only Enterprise Linux and Ubuntu)
init                           Create ssh key and cert to grant access on VM
update                         Update terraform plugins
apply                          Apply builds/changes resources. You should ALWAYS run a plan first.
destroy                        Destroys everything. There is a prompt before destruction.
graph                          Output the `dot` graph of all the built Terraform resources
plan                           Display all the changes that Terraform is going to make.
```

#### Example usage:
```
make install
make init
make apply
```

get openvpn.ovpn from root folder and connect to the new project

#### Project layout
```
$ tree -F -l
├── ansible/
│   ├── ansible.cfg
│   ├── envs/
│   │   ├── dev/
│   │   │   ├── dummy.yml
│   │   │   └── group_vars/
│   │   │       └── all/
│   │   │           └── bastion.yml -> ../../../bastion.yml
│   │   └── prod/
│   │       ├── dummy.yml
│   │       └── group_vars/
│   │           └── all/
│   │               └── bastion.yml -> ../../../bastion.yml
│   └── roles/
│       └── dummy.yml
├── extras/
│   ├── bastion.tpl
│   ├── OpenVPN.tpl
│   └── project.svg
├── Makefile
├── README.md
└── terraform/
    ├── ansiblegw-output.tf
    ├── ansiblegw.tf
    ├── backend.tf
    ├── cloud-init/
    │   ├── ansiblegw_runcmd.yml
    │   ├── ansiblegw_useradd.tpl
    │   └── ansiblegw_write_files.yml
    ├── network.tf
    ├── opnsense/
    │   ├── config-OPNsense-Backup.xml
    │   └── config-OPNsense-Master.xml
    ├── opnsense-output.tf
    ├── opnsense.tf
    ├── opnsense-var.tf
    ├── provider.tf
    ├── resources.tf
    └── variables.tf
```

### TODO
```
make a script to allow easy network customization (right now i'm doing it with sed)
make a scritt to allow opnsense root password customization
integrate ansible in Makefile
```
