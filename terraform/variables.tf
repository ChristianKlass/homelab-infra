variable "proxmox_endpoint" {
  type        = string
  description = "Proxmox API endpoint URL"
}

variable "proxmox_api_token" {
  type        = string
  sensitive   = true
  description = "Proxmox API token (format: user@realm!tokenid=secret)"
}

variable "network_gateway" {
  type        = string
  description = "Default network gateway for all LXCs and VMs"
  default     = "10.0.0.1"
}

variable "ssh_public_key" {
  type        = string
  description = "Public SSH key for VM access"
}
