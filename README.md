# Proxmox_Setup
 
This is a repository containing some of the scripts and tools I use to configure and deploy VM's from within my homelab. Included in this readme are some general notes on how to use the scripts and tools. As well as some resources that I have found useful in the past. If you're interested in using some of these scripts or have any questions please feel free to reach out. Ways to contact me are listed on my github page. 

## Table of Contents

- [Proxmox_Setup](#proxmox_setup)
  * [Table of Contents](#table-of-contents)
  * [General](#general)
  * [Proxmox](#proxmox)
  * [Packer](#packer)
    - [ubuntu-server-jammy-docker.pkr.hcl](#ubuntu-server-jammy-docker.pkr.hcl)
    - [user-data](#user-data)
  * [Terraform](#terraform)
  * [Ansible](#ansible)


## General

## Proxmox

## Packer

### ubuntu-server-jammy-docker.pkr.hcl
This script is used to create a new VM template on Proxmox with the following specifications:
- 2 CPU's
- 4GB of RAM
- 20GB of storage
- 1 Network Interface
Additionally, this script installs Docker on the VM once it has been created before it's converted into a template.

### user-data

## Terraform

## Ansible
