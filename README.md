# terraform-pve-devbox

For test purpose only.

```HCL
# RSA key of size 4096 bits
resource "tls_private_key" "cluster-ssh-private-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "tls_public_key" "cluster-ssh-public-key" {
  private_key_openssh = tls_private_key.cluster-ssh-private-key.private_key_openssh
}

module "pve-devbox" {
  source                     = "github.com/ethinx/terraform-pve-devbox"
  kind                       = "devbox"
  env                        = "dev"
  project                    = "pve"
  vm_count                   = 2
  cores                      = 4
  memory                     = 8192
  disk_size                  = "60G"
  github_id                  = "ethinx"
  os_password                = "linux"
  pve_node                   = "rome"
  disk_storage               = "pve"
  ci_storage                 = "pve"
  clone_template             = "ubuntu-22.04-cloudimg-template"
  network_bridge_nic         = "vmbr1"
  nameserver                 = "192.168.66.1"
  pdns_api_key               = "the-api-key-of-pdns"
  host_group_ssh_public_key  = data.tls_public_key.cluster-ssh-public-key.public_key_openssh
  host_group_ssh_private_key = tls_private_key.cluster-ssh-private-key.private_key_openssh
}

output "devbox-ips" {
  value = module.pve-devbox.ips
}
```

## Options

Please refer to the comments in file [variables.tf](./variables.tf)
