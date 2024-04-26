resource "proxmox_vm_qemu" "test1" {
    name = "test1"
    target_node = "pve"
    vmid = 100
    desc = "Test VM"
    agent = 1

    clone = "ubuntu-server-jammy"
    cores = 2
    sockets = 1
    cpu = "host"
    memory = 2048

    network {
        model = "virtio"
        bridge = "vmbr0"
    }

    os_type = "cloud-init"
    ipconfig0 = "ip=192.168.0.100/24,gw=192.168.0.1"
    nameserver = "192.168.0.10"
}