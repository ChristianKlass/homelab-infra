resource "proxmox_virtual_environment_container" "frigate" {
  node_name      = "forge"
  vm_id          = 127
  start_on_boot  = false
  timeout_clone  = 1800
  timeout_create = 1800
  timeout_delete = 60
  timeout_update = 1800

  console {
    enabled   = true
    tty_count = 2
    type      = "tty"
  }

  cpu {
    architecture = "amd64"
    cores        = 6
    limit        = 0
  }

  memory {
    dedicated = 8192
    swap      = 0
  }

  disk {
    datastore_id = "fast-storage"
    size         = 32
  }

  initialization {
    hostname = "frigate"
    ip_config {
      ipv4 {
        address = "10.0.0.63/24"
        gateway = var.network_gateway
      }
    }
    dns {
      servers = ["10.0.0.4"]
    }
  }

  network_interface {
    name        = "eth0"
    bridge      = "vmbr0"
  }

  operating_system {
    template_file_id = "local:vztmpl/placeholder"
    type             = "ubuntu"
  }

  unprivileged = false

  lifecycle {
    ignore_changes = [description, operating_system]
  }
}
