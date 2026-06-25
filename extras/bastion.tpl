ansible_ssh_common_args: \"-o ConnectTimeout=20 -o ProxyCommand='ssh -i ../.ssh/id_ed25519 -W %h:%p ansible@${bastion_ip}'\"
ansible_ssh_private_key_file: \"../.ssh/id_ed25519\"
ansible_ssh_user: \"ansible\"
