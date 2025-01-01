# Variables
variable "dns_server" {
  type    = string
  default = "192.168.0.10"
}

variable "gateway" {
  type    = string
  default = "192.168.0.1"
}

# Docker Services Container
resource "proxmox_virtual_environment_container" "docker_services" {
  node_name     = "pve"
  vm_id         = 101
  template_file = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.gz"

  initialization {
    hostname = "docker-services"
    ip_config {
      ipv4 {
        address = "192.168.0.101/24"
        gateway = var.gateway
      }
    }
    dns {
      servers = [var.dns_server]
    }
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 4096 # 4GB RAM
  }

  disk {
    datastore_id = "pool1"
    size         = 50
  }

  features {
    nesting = true # Required for Docker
  }

  unprivileged = true
}
