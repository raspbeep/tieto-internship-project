provider "proxmox" {
    pm_api_url = var.proxmox_host["pm_api_url"]
    pm_user = var.proxmox_host["pm_user"]
    pm_tls_insecure = true
    pm_password="TietoEVRY2021"
    pm_parallel = 10
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
  
  disk {
    type = var.storage["type"]
    storage = var.storage["storage"]
    size = var.rootfs_size
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
  
  disk {
    type = var.storage["type"]
    storage = var.storage["storage"]
    size = var.rootfs_size
  }

  sshkeys = file(var.ssh_keys["pub"])

  connection {
    host = var.k3s-node-hostnames[count.index]
    user = var.user
    private_key = file(var.ssh_keys["priv"])
    timeout = "5m"
  }

  provisioner "remote-exec" {
	  # Leave this here so we know when to start with Ansible local-exec 
    inline = [ "echo 'Cool, we are ready for provisioning'"]
  }

   provisioner "local-exec" {
      working_dir = "../ansible/"
      command = "ansible-playbook -u ${var.user} --key-file ${var.ssh_keys["priv"]} -i ${var.k3s-server-ips[count.index]}, provision.yaml"
  }

}


/*
resource "proxmox_vm_qemu" "k3s-load-balancer" {
  count = length(var.hostnames)
  name = var.hostnames[count.index]
  target_node = var.proxmox_host["target_node"]
  vmid = var.vmid + count.index
  
  clone = "clone"
  clone_wait = 30
  full_clone = true

  cores = 4
  sockets = 1
  vcpus = 2
  memory = 16384
  os_type="cloud-init"
  scsihw = "virtio-scsi-pci"
  
  network {
    name="eth0"
    bridge="vmbr0"
    ip="dhcp"
  }
  
  // ipconfig0 = "ip=${var.ips[count.index]}/24,gw=${cidrhost(format("%s/24", var.ips[count.index]), 1)}"
  
  disk {
    type = "virtio"
    storage = "local"
    size = "12G"
  }
  
  connection {
    host = var.ips[count.index]
    user = var.user
    private_key = file(var.ssh_keys["priv"])
  }
}
*/