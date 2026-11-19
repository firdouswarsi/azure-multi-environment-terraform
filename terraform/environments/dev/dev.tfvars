project_name       = "fw-multi"
environment        = "dev"
location           = "eastus"
vnet_address_space = ["10.10.0.0/16"]

subnets = {
  snet-workload = { prefix = "10.10.1.0/24" }
  snet-data     = { prefix = "10.10.2.0/24" }
}

workload_subnet_name = "snet-workload"

nsg_rules = [
  {
    name                       = "Allow-SSH-Dev"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  },
  {
    name                       = "Allow-HTTP-Dev"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }
]

vm_count        = 1
vm_size         = "Standard_B1s"
admin_username  = "azureuser"
ssh_public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3... dev-key"
os_disk_type    = "Standard_LRS"
os_disk_size_gb = 32

storage_replication_type   = "LRS"
key_vault_sku              = "standard"
key_vault_retention_days   = 7
key_vault_purge_protection = false
enable_strict_network_acls = false

tags = {
  CostCenter = "Engineering-Dev"
}
