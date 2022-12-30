# terraform-pve-devbox

For test purpose only.

```HCL
module "pve-devbox" {
  source             = "github.com/ethinx/terraform-pve-devbox"
  project            = "pve"
  kind               = "devbox"
  vm_count           = 2
  cores              = 4
  memory             = 8192
  disk_size          = "60G"
  github_id          = "ethinx"
  os_password        = "linux"
  pve_node           = "rome"
  disk_storage       = "pve"
  ci_storage         = "pve"
  clone_template     = "ubuntu-22.04-cloudimg-template"
  network_bridge_nic = "vmbr1"
}

output "devbox-ips" {
  value = module.pve-devbox.ips
}
```

## Options

Please refer to the comments in file [variables.tf](./variables.tf)
