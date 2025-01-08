# Specify the required provider and its version
terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "2.15.1"
    }
  }
}

# Configure the Vultr provider with the API key
provider "vultr" {
  api_key = var.vultr_api_key
}

# Define a Vultr instance
resource "vultr_instance" "RNS_Transport" {
  plan        = "vc2-1c-1gb"
  region      = "ewr"
  os_id       = "1743"
  label       = "RNS_Transport"
  ssh_key_ids = [var.ssh_key_id]
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/playbooks/templates/inventory.ini.tpl", { RNS_Transport_ip = vultr_instance.RNS_Transport.main_ip})
  filename = "${path.module}/playbooks/inventory.ini"
}

# Add a delay to ensure SSH is ready
resource "time_sleep" "wait_45_seconds" {
  depends_on = [vultr_instance.RNS_Transport]
  create_duration = "45s"
}

# Calculate hash of template file for change detection
data "local_file" "reticulum_template" {
  filename = "${path.module}/playbooks/roles/rnsd/templates/reticulum_config.j2"
}

resource "null_resource" "run_ansible" {
  depends_on = [local_file.ansible_inventory, time_sleep.wait_45_seconds]

  # Add triggers to detect changes
  triggers = {
    template_hash = data.local_file.reticulum_template.content_md5
    inventory_file = local_file.ansible_inventory.content
    playbook_run = timestamp() # Optional: forces playbook to run on every apply
  }

  provisioner "local-exec" {
   command = "cd playbooks && ANSIBLE_ROLES_PATH=./roles ansible-playbook -i inventory.ini setup_rnsd.yml --extra-vars 'automation_user=${var.automation_user} rns_interface_device=${var.rns_interface_device} rns_server_port=${var.rns_server_port} rns_node_name=${var.rns_node_name} ssh_public_key=\"${file(pathexpand(var.ssh_public_key_path))}\"'" 
  }
}