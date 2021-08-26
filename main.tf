provider "proxmox" {
    pm_api_url = var.proxmox_host["pm_api_url"]
    pm_user = var.proxmox_host["pm_user"]
    pm_tls_insecure = true
    pm_password=var.proxmox_host["pm_password"]
    pm_parallel = 10 // temporary fix
}

resource "proxmox_vm_qemu" "k3s-master-server" {
  name = var.k3s-master-server-hostname
  target_node = var.proxmox_host["target_node"]
  vmid = var.k3s-master-server-id
  
  clone = var.cloning["clone_template"]
  full_clone = var.cloning["full_clone"]
  clone_wait = var.cloning["clone_wait"]
  // additional_wait = 40

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
  
  ipconfig0 = "ip=${var.k3s-master-server-ip}/24,gw=${cidrhost(format("%s/24", var.k3s-master-server-ip), 1)}"
  nameserver = var.dns_nameserver

  ciuser = var.ciuser
  cipassword = var.cipassword
  sshkeys = file(var.ssh_keys["pub"])

  disk {
    slot = var.storage-resize["slot"]
    size = var.storage-resize["size"]
    storage  = var.storage-resize["storage"]
    type = var.storage-resize["type"]
  }

  provisioner "file" {
    source      = "ssh_keys/id_rsa"
    destination = "/root/.ssh/id_rsa"

    connection {
      type     = "ssh"
      user     = "root"
      private_key = file(var.ssh_keys["priv"])
      host     = var.k3s-master-server-ip
    }
  }
  provisioner "remote-exec" {
    inline = ["sudo chmod 600 ~/.ssh/id_rsa"]

    connection {
      type     = "ssh"
      user     = "root"
      private_key = file(var.ssh_keys["priv"])
      host     = var.k3s-master-server-ip
    }
  }
  

  # TODO: Dalsie commandy odtialto
  }

  resource "proxmox_vm_qemu" "k3s-server" {
  name = var.k3s-server-hostname
  target_node = var.proxmox_host["target_node"]
  vmid = var.k3s-server-id
  
  clone = var.cloning["clone_template"]
  full_clone = var.cloning["full_clone"]
  clone_wait = var.cloning["clone_wait"]
  // additional_wait = 40

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
  
  ipconfig0 = "ip=${var.k3s-server-ip}/24,gw=${cidrhost(format("%s/24", var.k3s-server-ip), 1)}"
  nameserver = var.dns_nameserver

  ciuser = var.ciuser
  cipassword = var.cipassword
  sshkeys = join("\n", [file(var.ssh_keys["pub"]), file("./ssh_keys/id_rsa.pub")])

  disk {
    slot = var.storage-resize["slot"]
    size = var.storage-resize["size"]
    storage  = var.storage-resize["storage"]
    type = var.storage-resize["type"]
  }
}

resource "proxmox_vm_qemu" "k3s-agent-node" {
  count = length(var.k3s-node-hostnames)
  name = var.k3s-node-hostnames[count.index]
  target_node = var.proxmox_host["target_node"]
  vmid = var.k3s-node-ids + count.index
  
  clone = var.cloning["clone_template"]
  full_clone = var.cloning["full_clone"]
  clone_wait = var.cloning["clone_wait"]
  // additional_wait = 40

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

  ciuser = var.ciuser
  cipassword = var.cipassword
  sshkeys = join("\n", [file(var.ssh_keys["pub"]), file("./ssh_keys/id_rsa.pub")])

  disk {
    slot = var.storage-resize["slot"]
    size = var.storage-resize["size"]
    storage  = var.storage-resize["storage"]
    type = var.storage-resize["type"]
  }
}

resource "proxmox_vm_qemu" "k3s-load-balancer" {
  count = length(var.k3s-load-balancer-hostnames)
  name = var.k3s-load-balancer-hostnames[count.index]
  target_node = var.proxmox_host["target_node"]
  vmid = var.k3s-load-balancer-ids + count.index
  
  clone = var.cloning["clone_template"]
  full_clone = var.cloning["full_clone"]
  clone_wait = var.cloning["clone_wait"]
  // additional_wait = 40

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

  ciuser = var.ciuser
  cipassword = var.cipassword
  sshkeys = join("\n", [file(var.ssh_keys["pub"]), file("./ssh_keys/id_rsa.pub")])

  disk {
    slot = var.storage-resize["slot"]
    size = var.storage-resize["size"]
    storage  = var.storage-resize["storage"]
    type = var.storage-resize["type"]
  }
}

resource "proxmox_vm_qemu" "k3s-db" {
  name = var.k3s-db-hostname
  target_node = var.proxmox_host["target_node"]
  vmid = var.k3s-db-id
  
  clone = var.cloning["clone_template"]
  full_clone = var.cloning["full_clone"]
  clone_wait = var.cloning["clone_wait"]
  // additional_wait = 40

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
  
  ipconfig0 = "ip=${var.k3s-db-ip}/24,gw=${cidrhost(format("%s/24", var.k3s-db-ip), 1)}"
  nameserver = var.dns_nameserver

  ciuser = var.ciuser
  cipassword = var.cipassword
  sshkeys = join("\n", [file(var.ssh_keys["pub"]), file("./ssh_keys/id_rsa.pub")])

  disk {
    slot = var.storage-resize["slot"]
    size = var.storage-resize["size"]
    storage  = var.storage-resize["storage"]
    type = var.storage-resize["type"]
  }
}