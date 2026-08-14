resource "proxmox_virtual_environment_container" "reddit_pipeline" {
  node_name      = "forge"
  vm_id          = 124
  start_on_boot  = true
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
    cores        = 4
    limit        = 0
  }

  memory {
    dedicated = 4096
    swap      = 1024
  }

  disk {
    datastore_id = "slow-storage"
    size         = 40
  }

  initialization {
    hostname = "reddit-pipeline"
    ip_config {
      ipv4 {
        address = "10.0.0.16/24"
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

  unprivileged = true

  lifecycle {
    ignore_changes = [operating_system]
  }
}
