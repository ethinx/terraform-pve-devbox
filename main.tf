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

data "http" "github-pub-keys" {
  url = "https://github.com/${var.github_id}.keys"
}

data "local_file" "ssh-pub-key" {
  filename = pathexpand("~/.ssh/id_rsa.pub")
}

resource "macaddress" "vm-macs" {
  count = var.vm_count
  // 52:54:00 - https://gist.github.com/ashee/9241ab6281e6f4d1ef9b
  prefix = [82, 84, 0]
}

resource "local_file" "cloud-init-user-data" {
  count = var.vm_count
  content = templatefile("${path.module}/cloud-init/cloud_init.cfg",
    {
      idx : "${count.index}",
      kind : "${var.kind}",
      env : "${var.env}",
      project : "${var.project}",
      colo : "${var.colo}",
      org_domain : "${var.org_domain}",
      nameserver : var.nameserver,
      github_id : var.github_id,
      os_password : var.os_password,
      apt_primary_mirror : var.apt_primary_mirror,
      apt_security_mirror : var.apt_security_mirror,
      github_pub_keys : split("\n", data.http.github-pub-keys.response_body),
      local_pub_key : data.local_file.ssh-pub-key,
      cluster_ssh_public_key  = var.host_group_ssh_public_key
      cluster_ssh_private_key = var.host_group_ssh_private_key
      custom_ca               = fileexists("/etc/squid/bump.crt") ? file("/etc/squid/bump.crt") : var.custom_ca
    }
  )

  filename = "/var/lib/vz/snippets/pve-devbox-user-data-${var.kind}${count.index}.${var.env}.${var.project}.${var.colo}.yml"
}

resource "local_file" "cloud-init-network-config" {
  count = var.vm_count
  content = templatefile("${path.module}/cloud-init/network_config.cfg", {
    macaddr = macaddress.vm-macs[count.index].address,
    idx : "${count.index}",
    kind : "${var.kind}",
    project : "${var.project}",
    colo : "${var.colo}",
    org_domain : "${var.org_domain}",
    nameserver : var.nameserver,
  })
  filename = "/var/lib/vz/snippets/pve-devbox-network-config-${var.kind}${count.index}.${var.env}.${var.project}.${var.colo}.yml"
}

output "macs" {
  value = macaddress.vm-macs.*
}

resource "proxmox_vm_qemu" "cloud-init-vm" {
  depends_on = [
    local_file.cloud-init-user-data,
    local_file.cloud-init-network-config,
  ]
  count       = var.vm_count
  name        = "${var.kind}${count.index}.${var.env}.${var.project}.${var.colo}.${var.org_domain}"
  target_node = var.pve_node
  clone       = var.clone_template
  full_clone  = var.full_clone
  os_type     = "cloud-init"
  agent       = 1

  onboot   = var.onboot
  oncreate = true
  memory   = var.memory
  cores    = var.cores
  cpu      = var.cpu_type

  boot     = "order=scsi0;scsi2"
  bootdisk = "scsi0"
  scsihw   = "virtio-scsi-pci"

  disk {
    type    = "scsi"
    storage = var.disk_storage
    size    = var.disk_size
    cache   = "writeback"
  }

  cicustom                = "user=local:snippets/pve-devbox-user-data-${var.kind}${count.index}.${var.env}.${var.project}.${var.colo}.yml,network=local:snippets/pve-devbox-network-config-${var.kind}${count.index}.${var.env}.${var.project}.${var.colo}.yml"
  cloudinit_cdrom_storage = var.ci_storage

  network {
    model   = "virtio"
    bridge  = var.network_bridge_nic
    macaddr = macaddress.vm-macs[count.index].address
  }

  lifecycle {
    ignore_changes = [
      # Ignore changes to disk, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      /* disk, network */
      disk, network
    ]
  }

  connection {
    type     = "ssh"
    user     = var.github_id
    password = var.os_password
    host     = self.ssh_host
    port     = self.ssh_port
  }

  provisioner "remote-exec" {
    inline = [
      "ip a"
    ]
  }
}

resource "powerdns_record" "vm-dns" {
  count   = var.vm_count
  zone    = "${var.org_domain}."
  name    = "${proxmox_vm_qemu.cloud-init-vm[count.index].name}."
  records = ["${proxmox_vm_qemu.cloud-init-vm[count.index].ssh_host}"]
  ttl     = 300
  type    = "A"
  set_ptr = true
}

output "ips" {
  value = proxmox_vm_qemu.cloud-init-vm.*.ssh_host
}
