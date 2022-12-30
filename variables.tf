variable "proxmox_api_url" {
  type    = string
  default = "https://127.0.0.1:8006/api2/json"
}

variable "vm_count" {
  type    = number
  default = 1
}

variable "kind" {
  type    = string
  default = "general"
}

variable "project" {
  type    = string
  default = "pve"
}

variable "disk_size" {
  type    = string
  default = "60G"
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

variable "colo" {
  type    = string
  default = "pek"
}

variable "org_domain" {
  type    = string
  default = "home.lab"
}

variable "github_id" {
  type = string
}

variable "clone_template" {
  type    = string
  default = "ubuntu-22.04-cloudimg-template"
}

variable "full_clone" {
  type    = bool
  default = true
}

variable "pve_node" {
  type    = string
  default = "rome"
}

variable "onboot" {
  type    = bool
  default = true
}

variable "os_password" {
  type    = string
  default = "linux"
}

variable "network_bridge_nic" {
  type    = string
  default = "vmbr0"
}

variable "searchdomain" {
  type    = string
  default = ""
}

variable "nameserver" {
  type    = string
  default = ""
}

variable "apt_primary_mirror" {
  type    = string
  default = "https://mirrors.tuna.tsinghua.edu.cn/ubuntu/"
}

variable "apt_security_mirror" {
  type    = string
  default = "https://mirrors.tuna.tsinghua.edu.cn/ubuntu/"
}
