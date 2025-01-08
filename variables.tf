variable "vultr_api_key" {
  description = "Vultr API Key"
  type        = string
  sensitive   = true
}

variable "ssh_key_id" {
  description = "SSH Key ID from Vultr"
  type        = string
  sensitive   = true
}

variable "rns_interface_device" {
  description = "Network interface device for RNS"
  type        = string
  default     = "enp1s0"
}

variable "rns_server_port" {
  description = "Port number for RNS server"
  type        = number
  default     = 4965
}

variable "rns_node_name" {
  description = "Name for your RNS node"
  type        = string
  default     = "RNS Net US-East"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "automation_user" {
  description = "Username for the automation user"
  type        = string
  default     = "ansible"
}