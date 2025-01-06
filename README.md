# Automated RNS Transport Node Deployment

This project automates the deployment of a [Reticulum Network Stack (RNS)](https://reticulum.network/) transport node on a Vultr VPS using Terraform and Ansible.

## Prerequisites

You should have the following installed on your local machine:
- [Terraform](https://www.terraform.io/downloads.html) (v1.10.3 or later)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (v2.15 or later)

You will also need:
- A Vultr account
- A Vultr API Key
- An SSH Key added to your Vultr account

To obtain your SSH key ID, run:
```bash
curl -H 'Authorization: Bearer YOUR_VULTR_API_KEY' https://api.vultr.com/v2/ssh-keys
```

## Configuration

1. Clone this repository and navigate to the project directory:
```bash
git clone https://github.com/yourusername/vultr_RNS.git
cd vultr_RNS
```

2. Copy the example variables file and edit it with your values:

```bash
cp terraform.tfvars.example terraform.tfvars
```

3. Edit `terraform.tfvars` file with your configuration:

```hcl
vultr_api_key         = "your-vultr-api-key"
ssh_key_id           = "your-ssh-key-id"
rns_interface_device = "enp1s0"  # Network interface device
rns_server_port      = 4965      # Port for RNS server
rns_node_name        = "My RNS Transport Node"  # Your node name
```

Note: The `terraform.tfvars` file contains sensitive information and is ignored by git to prevent accidentally committing your credentials.

Also, make sure to add `terraform.tfvars` to your `.gitignore` file if it's not already there:

```
# .gitignore
terraform.tfvars
.terraform/
*.tfstate
*.tfstate.*
```

## Deployment

1. Initialize Terraform:
```bash
terraform init
```

2. Review the planned changes:
```bash
terraform plan
```

3. Apply the configuration:
```bash
terraform apply
```

This will:
- Create a new VPS instance on Vultr
- Update and upgrade system packages
- Install and configure RNS
- Set up RNS as a system service
- Configure the firewall
- Connect to various RNS network nodes

## What Gets Deployed

The deployment creates:
- A 1 CPU, 1GB RAM VPS in Vultr's New Jersey datacenter
- Ubuntu 22.04 LTS operating system
- RNS transport node with connections to multiple network nodes
- UFW firewall configured to allow RNS traffic
- Systemd service for automatic RNS startup

## Customization

You can modify the following variables in `terraform.tfvars`:
- `rns_interface_device`: Network interface name
- `rns_server_port`: Port number for RNS server
- `rns_node_name`: Name of your transport node

To modify the VPS specifications, edit `main.tf`:
- `plan`: VPS size (default: vc2-1c-1gb)
- `region`: Datacenter location (default: ewr)

## Maintenance

To check the status of your RNS node:
```bash
ssh root@<your-vps-ip> 'systemctl status rnsd'
```

To view logs:
```bash
ssh root@<your-vps-ip> 'journalctl -u rnsd'
```

## Cleanup

To destroy the infrastructure:
```bash
terraform destroy
```

## Support the Project
If you're new to Vultr and would like to support this project, you can use one of our referral links when signing up:

### Option 1: $300 Credit for New Users
- [Sign up with this link](https://www.vultr.com/?ref=9683297-9J)
- New users receive $300 in credits to test the platform
- The project receives $100 when you become an active user
- Requires minimum $100 usage and 30+ days of activity
- Credit expires after 30 days if unused

### Option 2: Standard Referral
- [Sign up with this link](https://www.vultr.com/?ref=9515472)
- The project receives $10 when you become an active user
- Requires minimum $10 usage and 30+ days of activity

**Note:** These are affiliate/referral links. Using them is completely optional and doesn't affect the functionality of this project. You can also sign up directly at [Vultr.com](https://www.vultr.com) without using any referral link.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

[MIT License](LICENSE)

## Acknowledgments

- [Reticulum Network Stack](https://reticulum.network/)
- [Vultr](https://www.vultr.com/)
- The RNS community

## Support

If you encounter any issues, please open an issue in this repository.
