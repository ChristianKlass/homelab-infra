resource "proxmox_virtual_environment_vm" "gitlab" {
  name      = "gitlab"
  node_name = "forge"
  vm_id     = 125

  agent {
    enabled = true
    type    = "virtio"
  }

  cpu {
    cores   = 4
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = 12288
  }

  disk {
    datastore_id = "fast-storage"
    interface    = "scsi0"
    file_format  = "raw"
    size         = 128
    discard      = "on"
    ssd          = true
  }

  initialization {
    datastore_id = "fast-storage"
    ip_config {
      ipv4 {
        address = "10.0.0.17/24"
        gateway = var.network_gateway
      }
    }
    user_account {
      username = "mark"
      keys     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPM32FvAAVBeCugeDmjYJNAjyrpc0ZPURiEC+bXeyO47 mark@Marks-MacBook-Pro.local"]
    }
  }

  network_device {
    bridge      = "vmbr0"
    model       = "virtio"
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
  tags            = ["gitlab"]

  lifecycle {
    ignore_changes = [initialization[0].user_account[0].password]
  }

}
