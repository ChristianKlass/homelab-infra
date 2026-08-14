resource "proxmox_virtual_environment_download_file" "ubuntu_noble_cloudimg" {
  content_type = "import"
  datastore_id = "local"
  node_name    = "forge"
  url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  file_name    = "noble-server-cloudimg-amd64.qcow2"
  overwrite    = false
}

resource "proxmox_virtual_environment_vm" "gateway" {
  name      = "gateway"
  node_name = "forge"
  vm_id     = 132

  agent {
    enabled = true
    trim    = true
    type    = "virtio"
  }

  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = 4096
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    file_format  = "raw"
    size         = 32
    discard      = "on"
    ssd          = true
    import_from  = proxmox_virtual_environment_download_file.ubuntu_noble_cloudimg.id
  }

  initialization {
    datastore_id = "local-lvm"
    ip_config {
      ipv4 {
        address = "10.0.0.99/24"
        gateway = var.network_gateway
      }
    }
    dns {
      servers = ["10.0.0.4"]
    }
    user_account {
      username = "mark"
      keys     = [trimspace(file("~/.ssh/id_ed25519.pub"))]
    }
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  serial_device {
    device = "socket"
  }

  vga {
    memory = 16
    type   = "std"
  }

  operating_system {
    type = "l26"
  }

  boot_order      = ["scsi0"]
  keyboard_layout = "en-us"
  scsi_hardware   = "virtio-scsi-pci"
  on_boot         = true
  tags            = ["gateway"]

  lifecycle {
    ignore_changes = [initialization[0].user_account[0].password]
  }
}
