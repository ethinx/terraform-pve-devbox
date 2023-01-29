# terraform-pve-devbox

For test purpose only.

According to [terraform documentation](https://developer.hashicorp.com/terraform/language/modules/develop/providers#implicit-provider-inheritance), please config providers in the root modules at first, e.g.

```HCL
terraform {
  required_version = ">= 0.12"
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
    }
    macaddress = {
      source  = "ivoronin/macaddress"
      version = "0.3.0"
    }
    powerdns = {
      source = "pan-net/powerdns"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.proxmox_api_url
  pm_tls_insecure = true
}

provider "powerdns" {
  api_key    = "pdns-api-key-here"
  server_url = var.pdns_server_url
}

```

Use the module:

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
  source                     = "github.com/ethinx/terraform-pve-devbox?ref=v0.0.5"
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
  host_group_ssh_public_key  = data.tls_public_key.cluster-ssh-public-key.public_key_openssh
  host_group_ssh_private_key = tls_private_key.cluster-ssh-private-key.private_key_openssh
}

output "devbox-ips" {
  value = module.pve-devbox.ips
}
```

## Options

Please refer to the comments in file [variables.tf](./variables.tf)
