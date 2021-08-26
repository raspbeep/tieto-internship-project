variable "proxmox_host" {
	type = map
    default = {
      pm_api_url = "https://localhost:8006/api2/json"
      pm_user = "root@pam"
      pm_password = "TietoEVRY2021"
      target_node = "pve-01"
    }
}

variable "ciuser" {
	default     = "root"
	description = "User used to SSH into the machine and provision it"
}

variable "cipassword" {
	default     = "root"
	description = "User used to SSH into the machine and provision it"
}

variable "machine" {
  description = "VM specifications"
  type = map
  default = {
    cores = 1
    sockets = 1
    memory = 4096
    os_type = "cloud-init"
    scsihw = "virtio-scsi-pci"
    qemu-agent = 1
  }
}

variable "dns_nameserver" {
  description = "DNS nameserver to set on all nodes"
  default = "8.8.8.8"
}

variable "cloning" {
  description = "Cloning options for all VMs created"
  type = map
  default = {
    clone_template = "clone"
    full_clone = false
    clone_wait = 15 // temporary fix
  }
}

variable "k3s-master-server-id" {
	description = "Id for master server node"
  default     = 135
}

variable "k3s-server-id" {
	description = "Id for server node"
  default     = 140
}

variable "k3s-node-ids" {
	description = "Starting ID for the k3s agent nodes"
  default     = 155
}

variable "k3s-load-balancer-ids" {
	description = "Starting ID for the k3s load balancer nodes"
  default     = 170
}

variable "k3s-db-id" {
	description = "ID for the k3s datastore node"
  default     = 180
}

variable "k3s-master-server-hostname" {
  description = "Master to be created"
  default     = "k3s-master-server"
}

variable "k3s-server-hostname" {
  description = "Server to be created"
  default     = "k3s-server"
}

variable "k3s-node-hostnames" {
  description = "Worker nodes to be created"
  type        = list(string)
  default     = ["k3s-node1", "k3s-node2", "k3s-node3", "k3s-node4"]
}

variable "k3s-load-balancer-hostnames" {
  description = "Load balancer nodes to be created"
  type        = list(string)
  default     = ["k3s-load-balancer"]
}

variable "k3s-db-hostname" {
  description = "Database to be created"
  default     = "k3s-db"
}

variable "k3s-master-server-ip" {
  description = "IP of the master"
  default     = "10.0.0.35"
}

variable "k3s-server-ip" {
  description = "IP of the server"
  default     = "10.0.0.40"
}

variable "k3s-node-ips" {
  description = "IPs of the nodes, respective to the hostname order"
  type        = list(string)
  default     = ["10.0.0.50", "10.0.0.51", "10.0.0.52", "10.0.0.53"]
}

variable "k3s-load-balancer-ips" {
  description = "IPs of the servers, respective to the hostname order"
  type        = list(string)
  default     = ["10.0.0.60"]
}

variable "k3s-db-ip" {
  description = "IP of the database"
  default     = "10.0.0.70"
}

variable "ssh_keys" {
	type = map
    default = {
      pub  = "~/.ssh/id_rsa.pub"
      priv = "~/.ssh/id_rsa"
    } 
}

variable "storage-resize" {
  type = map
	default = {
    slot = 0
    type = "scsi"
    storage = "local"
    size = "5G"
  }
}