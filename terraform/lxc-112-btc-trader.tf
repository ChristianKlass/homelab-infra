resource "proxmox_virtual_environment_container" "btc_trader" {
  node_name      = "forge"
  vm_id          = 112
  started        = false
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
    cores        = 2
    limit        = 0
  }

  memory {
    dedicated = 512
    swap      = 512
  }

  disk {
    datastore_id = "slow-storage"
    size         = 10
  }

  initialization {
    hostname = "btc-trader"
    ip_config {
      ipv4 {
        address = "10.0.0.209/24"
        gateway = var.network_gateway
      }
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
