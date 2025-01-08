
# Automated RNS Transport Node Deployment
This project automates the deployment of a [Reticulum Network Stack (RNS)](https://reticulum.network/) transport node on a Vultr VPS using Terraform and Ansible.

## Prerequisites
You should have the following installed on your local machine:
- [Terraform](https://www.terraform.io/downloads.html) (v1.10.3 or later)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (v2.15 or later)

You will also need:
- A Vultr account
- A Vultr API Key
- An SSH key pair on your local machine

### Getting Your Vultr SSH Key ID
After adding your SSH key to Vultr, get your SSH key ID by running:
```bash
curl -H 'Authorization: Bearer YOUR_VULTR_API_KEY' https://api.vultr.com/v2/ssh-keys
```

## Configuration

1. Clone this repository and navigate to the project directory:
```bash
git clone https://github.com/yourusername/vultr_RNS.git
cd vultr_RNS
```

2. Copy the example variables file:
```bash
cp terraform.tfvars.example terraform.tfvars
```

3. Configure your deployment by editing `terraform.tfvars`:
```hcl
# Vultr Configuration
vultr_api_key = "your-vultr-api-key"
ssh_key_id    = "your-ssh-key-id"

# RNS Configuration
rns_interface_device = "enp1s0"    # Network interface name
rns_server_port     = 4965         # Port for RNS server
rns_node_name       = "My_RNS_Transport_Node"

# Security Configuration
automation_user  = "ansible"        # User that will run the RNS service
ssh_key_path    = "~/ansible.pub"  # Path to your SSH public key
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

### Configuration Variables Explained
- `vultr_api_key`: Your Vultr API key for creating resources
- `ssh_key_id`: The ID of your SSH key in Vultr (obtained from the curl command above)
- `rns_interface_device`: Network interface name (usually "enp1s0" on Vultr)
- `rns_server_port`: Port for RNS communications (default: 4965)
- `rns_node_name`: Name to identify your transport node
- `automation_user`: Username for the service account (default: ansible)
- `ssh_key_path`: Path to your SSH public key file

## Deployment

1. Initialize Terraform:
```bash
terraform init
```

2. Review the planned changes:
```bash
terraform plan
```

3. Deploy the infrastructure:
```bash
terraform apply
```

### What Gets Deployed
- VPS Instance:
  - 1 CPU, 1GB RAM (vc2-1c-1gb)
  - Ubuntu 22.04 LTS
  - Located in Vultr's New Jersey datacenter (ewr)

- Software & Configuration:
  - RNS transport node
  - UFW firewall (configured for RNS)
  - Systemd service for RNS
  - Security hardening

### Security Features
The deployment implements several security best practices:
- Creates a non-root service account (default: ansible)
- Disables root and password-based login
- Enables only key-based SSH authentication
- Configures UFW firewall
- Runs RNS service as non-root user

## Post-Deployment Management

### Checking Service Status
```bash
# Replace with your server's IP and automation_user name
ssh automation_user@<server-ip> 'systemctl status rnsd'
```

### Viewing Logs
```bash
ssh automation_user@<server-ip> 'journalctl -u rnsd -f'
```

### Modifying VPS Specifications
To change VPS size or location, edit these values in `main.tf`:
```hcl
plan   = "vc2-1c-1gb"  # VPS size
region = "ewr"         # Datacenter location
```

## Cleanup
To remove all created resources:
```bash
terraform destroy
```

## Support the Project

### Vultr Referral Options

#### Option 1: $300 Credit (New Users)
- [Sign up here](https://www.vultr.com/?ref=9683297-9J)
- Get $300 in credits (30-day expiry)
- Project receives $100 after $100 usage

#### Option 2: Standard Referral
- [Sign up here](https://www.vultr.com/?ref=9515472)
- Project receives $10 after $10 usage

**Note:** Using referral links is optional and doesn't affect functionality.

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
[MIT License](LICENSE)

## Acknowledgments
- [Reticulum Network Stack](https://reticulum.network/)
- [Vultr](https://www.vultr.com/)
- The RNS community

## Support
For issues or questions, please open an issue in this repository.