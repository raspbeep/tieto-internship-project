variable "proxmox_host" {
	type = map
    default = {
      pm_api_url = "https://localhost:20001/api2/json"
      pm_user = "root@pam"
      target_node = "pve-01"
    }
}

/*
variable "machine" {
  // TODO: fill in information
  // cores
  // sockets
  // ...
}
*/


variable "k3s-server-ids" {
	description = "Starting ID for k3s servers"
  default     = 105
}

variable "k3s-node-ids" {
	description = "Starting ID for the k3s agent nodes"
  default     = 205
}

variable "k3s-server-hostnames" {
  description = "Servers to be created"
  type        = list(string)
  default     = ["k3s-server1", "k3s-server2"]
}

variable "k3s-node-hostnames" {
  description = "Worker nodes to be created"
  type        = list(string)
  default     = ["k3s-node1", "k3s-node2", "k3s-node3", "k3s-node4"]
}

variable "k3s-server-ips" {
  description = "IPs of the servers, respective to the hostname order"
  type        = list(string)
  default     = ["10.0.0.40", "10.0.0.41"]
}

variable "k3s-node-ips" {
  description = "IPs of the nodes, respective to the hostname order"
  type        = list(string)
  default     = ["10.0.0.42", "10.0.0.43", "10.0.0.44", "10.0.0.45"]
}

// Config variables for Ansible
variable "ssh_keys" {
	type = map
    default = {
      pub  = "~/.ssh/id_rsa.pub"
      priv = "~/.ssh/id_rsa"
    } 
}

variable "user" {
	default     = "root"
	description = "User used to SSH into the machine and provision it"
}

variable "rootfs_size" {
	default = "3G"
}