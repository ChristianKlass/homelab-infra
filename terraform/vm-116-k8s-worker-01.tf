resource "proxmox_virtual_environment_vm" "k8s_worker_01" {
  name      = "k8s-worker-01"
  node_name = "forge"
  vm_id     = 116

  agent {
    enabled = true
    type    = "virtio"
  }

  cpu {
    cores   = 8
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = 16384
  }

  disk {
    datastore_id = "fast-storage"
    interface    = "scsi0"
    iothread     = true
    file_format  = "raw"
    size         = 128
  }

  disk {
    datastore_id = "fast-storage"
    interface    = "scsi1"
    iothread     = true
    file_format  = "raw"
    size         = 62
  }

  initialization {
    datastore_id = "fast-storage"
    ip_config {
      ipv4 {
        address = "10.0.0.31/24"
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
  scsi_hardware   = "virtio-scsi-single"
  on_boot         = true

  lifecycle {
    ignore_changes = [operating_system]
  }
}
