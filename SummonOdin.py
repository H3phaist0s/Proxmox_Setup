from proxmoxer import ProxmoxAPI
# Read configuration from file
config_file = './Configs/Odin.txt'  # Update with the actual path to your config file

with open(config_file, 'r') as f:
    config = f.read().splitlines()

# Extract values from config
proxmox_host = config[0]
node = config[1]
api_token_name = config[2]
api_token = config[3]
user = config[4]
storage_iso = config[5]
storage_volume = config[6]

# Convert vmid to integer
vmid = int(config[7])

# Initialize Proxmox API
proxmox = ProxmoxAPI(proxmox_host, user=user, token_name=api_token_name, token_value=api_token, verify_ssl=False)

# Create VM
try:
    storage = proxmox.nodes(node).get('storage')
    iso_store = next((s for s in storage if s['storage'] == storage_iso), None)
    if iso_store is None:
        raise Exception('Storage not found.')
    files = proxmox.nodes(node).storage(storage_iso).content.get()
    iso = next((f for f in files if f['volid'].startswith('local:iso/ubuntu')), None)
    if iso is None:
        raise Exception('Ubuntu ISO not found in the storage.')
    
    # Specify the ISO for the OS installation
    cd = f"{iso['volid']},media=cdrom"
    disk = f"{storage_volume}:32"
    #disk = f"file={iso_store['storage']},format=qcow2,size=32G,discard=on"
    
    proxmox.nodes(node).qemu.post(
        node=node,
        vmid=vmid,
        name='Odin',
        cores=2,
        memory=2048,
        net0='model=virtio,bridge=vmbr0',
        start=1,
        ostype='l26',  # Linux 2.6/3.x/4.x
        cdrom=cd,
        scsihw='virtio-scsi-pci',
        virtio0=disk
    )
    print(f'VM Odin with ID {vmid} has been created.')
except Exception as e:
    print(f"An error occurred: {e}")
