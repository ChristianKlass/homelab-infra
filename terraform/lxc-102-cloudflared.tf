resource "proxmox_virtual_environment_container" "cloudflared" {
  node_name      = "forge"
  vm_id          = 102
  start_on_boot  = true
  tags           = ["cloudflare", "community-script", "network"]
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
    dedicated = 256
    swap      = 512
  }

  disk {
    datastore_id = "slow-storage"
    size         = 2
  }

  initialization {
    hostname = "cloudflared"
    ip_config {
      ipv4 {
        address = "10.0.0.5/24"
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
    order      = 1
    up_delay   = 30
    down_delay = -1
  }

  lifecycle {
    ignore_changes = [description, operating_system]
  }
}
