#!/bin/bash

# Check if the VM already exists
if qm status $VMID >/dev/null 2>&1; then
    echo "Template VM with ID $VMID already exists. Removing..."
    # Stop the VM if it's running
    qm stop $VMID --skiplock true
    # Wait for the VM to stop
    sleep 10
    # Remove the VM
    qm destroy $VMID --purge true
fi

# Get a list of all VM IDs
VM_IDS=$(qm list | awk 'NR>1 {print $1}')

# Check if there are any VMs to delete
if [ -z "$VM_IDS" ]; then
    echo "No VMs found to delete."
else
    # Confirm before deletion
    echo "The following VMs will be deleted: $VM_IDS"
    read -p "Are you sure you want to delete all VMs? (y/n) " -n 1 -r
    echo    # Move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]] then
        echo "VM deletion canceled."
    else
        # Delete each VM
        for VM_ID in $VM_IDS; do
            echo "Deleting VM $VM_ID..."
            # Stop the VM first, ignoring locks
            qm stop $VM_ID --skiplock true
            # Wait for the VM to be stopped
            sleep 10
            # Remove the VM
            qm destroy $VM_ID --purge true
            echo "VM $VM_ID deleted."
        done
        echo "All VMs have been removed."
    fi
fi

echo "Downloading latest version of Ubuntu server."
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64-disk-kvm.img -O /var/lib/vz/template/iso/ubuntu-cloud.img

echo "Creating a new VM template from the downloaded image."
VMID=9000
qm create $VMID --name "ubuntu-template" --memory 2048 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci

echo "Importing the downloaded image to the VM template."
qm set 9000 --scsi0 local-lvm:0,import-from=/var/lib/vz/template/iso/ubuntu-cloud.img --silent

echo "Configuring the CDROM drive with cloudinit image."
qm set $VMID --ide2 local-lvm:cloudinit

ehco "Setting boot order to scsi0."
qm set $VMID --boot order=scsi0

echo "Setting serial console for the VM."
qm set $VMID --serial0 socket --vga serial0

echo "Converting the VM to a template."
qm template $VMID
echo "Template created with VMID $VMID"

TEMPLATE_VMID=$VMID

# Load configurations
ENABLE_PROXY=$(awk -F " = " '/enable_proxy/ {print $2}' config.ini)
IP_BLOCK=$(awk -F " = " '/ip_block/ {print $2}')

# Define VMID for the proxy
PROXY_VMID=8000

if [ "$ENABLE_PROXY" = "true" ]; then
    echo "Deploying Squid Proxy Server..."
    
    # Check if the Proxy VM already exists
    if qm status $PROXY_VMID >/dev/null 2>&1; then
        echo "Proxy VM with ID $PROXY_VMID already exists. Removing..."
        qm stop $PROXY_VMID --skiplock true
        sleep 10
        qm destroy $PROXY_VMID --purge true
    fi

    # Create and configure the Proxy VM
    qm clone $TEMPLATE_VMID $PROXY_VMID --name "squid-proxy"

    echo "Squid Proxy deployed with VMID $PROXY_VMID"
else
    echo "Proxy deployment is skipped as per configuration."
fi

# Read service names from a config file
mapfile -t services < services.txt #TODO: Update how we read the config file

# Define starting VMID for the service VMs
START_VMID=9010

# Loop over services and create a VM for each
for i in "${!services[@]}"; do
    VMID=$(($START_VMID + $i))
    SERVICENAME=${services[$i]}

    # Clone the template
    qm clone $TEMPLATE_VMID $VMID --name "$SERVICENAME"

    # Set VM-specific configurations (if any)
    # e.g., Adjust memory or disk space based on service requirements
    qm set $VMID --memory 4096 # example adjustment

    # Start VM
    qm start $VMID

    echo "Deployed $SERVICENAME on VMID $VMID"
done
