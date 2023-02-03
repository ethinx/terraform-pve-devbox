// PVE api address
variable "proxmox_api_url" {
  type    = string
  default = "https://127.0.0.1:8006/api2/json"
}

variable "pdns_server_url" {
  type    = string
  default = "http://127.0.0.1:8081"
}

variable "vm_count" {
  type    = number
  default = 1
}

// The vm will be named in format
// ${kind}${count.index}.${project}.${colo}.${org_domain}
variable "kind" {
  type    = string
  default = "general"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "project" {
  type    = string
  default = "pve"
}

variable "colo" {
  type    = string
  default = "pek"
}

variable "org_domain" {
  type    = string
  default = "home.lab"
}

variable "cores" {
  type    = number
  default = 2
}

// https://pve.proxmox.com/pve-docs/chapter-qm.html#qm_cpu
variable "cpu_type" {
  type    = string
  default = "kvm64"
}

// size in MB
variable "memory" {
  type    = number
  default = 4096
}

variable "disk_size" {
  type    = string
  default = "60G"
}

// The storage of the VM SCSI disk
variable "disk_storage" {
  type = string
}

// The storage of the cloud-init data files
variable "ci_storage" {
  type = string
}

// The default OS username will be the github_id
variable "github_id" {
  type = string
}

variable "os_password" {
  type = string
}

// The PVE template name which will be cloned
variable "clone_template" {
  type = string
}

// https://pve.proxmox.com/pve-docs/chapter-qm.html#qm_copy_and_clone
variable "full_clone" {
  type    = bool
  default = true
}

// The node name where the VM will be placed
variable "pve_node" {
  type = string
}

// Auto start the VM after PVE boot up
variable "onboot" {
  type    = bool
  default = true
}

// The host bridge name that the VM will be bonded to
variable "network_bridge_nic" {
  type    = string
  default = "vmbr0"
}

// manually set the VM's nameserver
variable "nameserver" {
  type    = string
  default = ""
}

// Set apt mirror here
// https://cloudinit.readthedocs.io/en/latest/topics/examples.html#add-primary-apt-repositories
variable "apt_primary_mirror" {
  type    = string
  default = "https://mirrors.tuna.tsinghua.edu.cn/ubuntu/"
}

variable "apt_security_mirror" {
  type    = string
  default = "https://mirrors.tuna.tsinghua.edu.cn/ubuntu/"
}

variable "host_group_ssh_public_key" {
  type = string
}

variable "host_group_ssh_private_key" {
  type = string
}

variable "custom_ca" {
  type    = string
  default = ""
}
