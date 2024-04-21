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
  * [WIP](#wip)

## General

Currently my homelab is running on a Proxmox server. I use Packer to create new VM templates and Terraform to deploy new VM's from those templates. The end goal is to create general purpose scripts and tools for other users who are looking at how to get into self-hosting and homelabbing.

## Proxmox

Proxmox is a debian based [type 1 hypervisor](https://en.wikipedia.org/wiki/Hypervisor#Classification). It's open source and has extensive community support from its dedicated userbase. In the wake of VMWare's acquisition by Broadcom I know a lot of VMWare users sought to jump ship and landed on Proxmox. I personally enjoy using it, it's a great platform for deploying and managing virtual machines. There are plenty of intergrations with other open source tools such as Packer, Terraform and Ansible which allow for the automation of a lot of tasks. Proxmox also supports LXC containers, which run with less overhead then convential virtual machines and are less taxing on the physical hardware of the host. I think it's fair to say Proxmox has a bit of a learning curve but its well worth the trouble. For more info you can visit their official [site](https://www.proxmox.com/en/proxmox-virtual-environment/overview).

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

## WIP
Ansible, Terraform, are still currently WIP. I am working on creating a more automated way to deploy VM's from the templates created by Packer and then managing them with Ansible. 
