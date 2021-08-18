provider "proxmox" {
    pm_api_url = var.proxmox_host["pm_api_url"]
    pm_user = var.proxmox_host["pm_user"]
    pm_tls_insecure = true
    pm_password=var.proxmox_host["pm_password"]
    pm_parallel = 10 // temporary fix
}

resource "proxmox_vm_qemu" "k3s-server" {
  count = length(var.k3s-server-hostnames)
  name = var.k3s-server-hostnames[count.index]
  target_node = var.proxmox_host["target_node"]
  vmid = var.k3s-server-ids + count.index
  
  clone = var.cloning["clone_template"]
  full_clone = var.cloning["full_clone"]
  clone_wait = var.cloning["clone_wait"]

  cores = var.machine["cores"]
  sockets = var.machine["sockets"]
  memory = var.machine["memory"]
  os_type = var.machine["os_type"]
  scsihw = var.machine["scsihw"]
  agent = var.machine["qemu-agent"]
  
  network {
    bridge = "vmbr1"
    model = "virtio"
  }
  
  ipconfig0 = "ip=${var.k3s-server-ips[count.index]}/24,gw=${cidrhost(format("%s/24", var.k3s-server-ips[count.index]), 1)}"
  nameserver = var.dns_nameserver

  disk {
    type = var.storage["type"]
    storage = var.storage["storage"]
    size = var.rootfs_size
  }
  ciuser = "root"
  cipassword = "root"
  sshkeys = file(var.ssh_keys["pub"])
}

resource "proxmox_vm_qemu" "k3s-agent-node" {
  count = length(var.k3s-node-hostnames)
  name = var.k3s-node-hostnames[count.index]
  target_node = var.proxmox_host["target_node"]
  vmid = var.k3s-node-ids + count.index
  
  clone = var.cloning["clone_template"]
  full_clone = var.cloning["full_clone"]
  clone_wait = var.cloning["clone_wait"]

  cores = var.machine["cores"]
  sockets = var.machine["sockets"]
  memory = var.machine["memory"]
  os_type = var.machine["os_type"]
  scsihw = var.machine["scsihw"]
  agent = var.machine["qemu-agent"]

  network {
    bridge = "vmbr1"
    model = "virtio"
  }
  
  ipconfig0 = "ip=${var.k3s-node-ips[count.index]}/24,gw=${cidrhost(format("%s/24", var.k3s-node-ips[count.index]), 1)}"
  nameserver = var.dns_nameserver

  disk {
    type = var.storage["type"]
    storage = var.storage["storage"]
    size = var.rootfs_size
  }

  ciuser = "root"
  cipassword = "root"
  sshkeys = file(var.ssh_keys["pub"])
}

resource "proxmox_vm_qemu" "k3s-load-balancer" {
  count = length(var.k3s-load-balancer-hostnames)
  name = var.k3s-load-balancer-hostnames[count.index]
  target_node = var.proxmox_host["target_node"]
  vmid = var.k3s-load-balancer-ids + count.index
  
  clone = var.cloning["clone_template"]
  full_clone = var.cloning["full_clone"]
  clone_wait = var.cloning["clone_wait"]

  cores = var.machine["cores"]
  sockets = var.machine["sockets"]
  memory = var.machine["memory"]
  os_type = var.machine["os_type"]
  scsihw = var.machine["scsihw"]
  agent = var.machine["qemu-agent"]

  network {
    bridge = "vmbr1"
    model = "virtio"
  }
  
  ipconfig0 = "ip=${var.k3s-load-balancer-ips[count.index]}/24,gw=${cidrhost(format("%s/24", var.k3s-load-balancer-ips[count.index]), 1)}"
  nameserver = var.dns_nameserver

  disk {
    type = var.storage["type"]
    storage = var.storage["storage"]
    size = var.rootfs_size
  }
  ciuser = "root"
  cipassword = "root"
  sshkeys = file(var.ssh_keys["pub"])
}