resource "proxmox_virtual_environment_container" "adguard" {
  node_name      = "forge"
  vm_id          = 100
  start_on_boot  = true
  tags           = ["adblock", "community-script"]
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
    cores        = 1
    limit        = 0
  }

  memory {
    dedicated = 512
    swap      = 512
  }

  disk {
    datastore_id = "slow-storage"
    size         = 4
  }

  initialization {
    hostname = "adguard"
    ip_config {
      ipv4 {
        address = "10.0.0.4/24"
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
    type             = "debian"
  }

  unprivileged = true

  startup {
    order      = 4
    up_delay   = 20
    down_delay = -1
  }

  lifecycle {
    ignore_changes = [description, operating_system]
  }
}
