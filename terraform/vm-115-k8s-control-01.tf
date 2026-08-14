resource "proxmox_virtual_environment_vm" "k8s_control_01" {
  name      = "k8s-control-01"
  node_name = "forge"
  vm_id     = 115

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
    dedicated = 4096
  }

  disk {
    datastore_id = "fast-storage"
    interface    = "scsi0"
    iothread     = true
    file_format  = "raw"
    size         = 32
  }

  initialization {
    datastore_id = "fast-storage"
    ip_config {
      ipv4 {
        address = "10.0.0.30/24"
        gateway = var.network_gateway
      }
    }
    user_account {
      keys = [var.ssh_public_key]
    }
  }

  network_device {
    bridge      = "vmbr0"
    model       = "virtio"
    firewall    = false
  }

  serial_device {
    device = "socket"
  }

  boot_order      = []
  keyboard_layout = "en-us"
  scsi_hardware   = "virtio-scsi-pci"
  on_boot         = true

  lifecycle {
    ignore_changes = [operating_system]
  }
}
