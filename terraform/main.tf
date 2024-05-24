resource "proxmox_virtual_environment_vm" "VM" {
    count = 1
    name = "VM-${count.index}"
    node_name = "pve"
    
    clone {
        vm_id = 1337
        full = true
    }

    initialization {

        datastore_id = "local-lvm"

        ip_config {
            ipv4 {
                address = "192.168.0.${count.index + 100}/24"
                gateway = "192.168.0.1"
            }
        }

        dns {
            servers = ["192.168.0.10"]
        }
    }

    network_device {
        bridge = "vmbr0"
        model = "virtio"
    }

}
