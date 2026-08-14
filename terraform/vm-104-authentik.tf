resource "proxmox_virtual_environment_vm" "authentik" {
  name      = "authentik"
  node_name = "forge"
  vm_id     = 104

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
    dedicated = 2560
    floating  = 2560
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    iothread     = true
    file_format  = "raw"
    size         = 42
  }

  network_device {
    bridge      = "vmbr0"
    model       = "virtio"
    firewall    = true
  }

  operating_system {
    type = "l26"
  }

  boot_order      = ["scsi0", "ide2", "net0"]
  keyboard_layout = "en-us"
  scsi_hardware   = "virtio-scsi-single"
  on_boot         = true

  startup {
    order    = 2
    up_delay = 30
  }

  lifecycle {
    ignore_changes = [description]
  }
}
