project_name       = "fw-multi"
environment        = "prod"
location           = "eastus"
vnet_address_space = ["10.30.0.0/16"]

subnets = {
  snet-workload = { prefix = "10.30.1.0/24" }
  snet-data     = { prefix = "10.30.2.0/24" }
}

workload_subnet_name = "snet-workload"

nsg_rules = [
  {
    name                       = "Allow-HTTPS-Prod"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }
]

vm_count        = 4
vm_size         = "Standard_D2s_v5"
admin_username  = "azureuser"
ssh_public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3... prod-key"
os_disk_type    = "Premium_LRS"
os_disk_size_gb = 128

storage_replication_type   = "GRS"
key_vault_sku              = "premium"
key_vault_retention_days   = 30
key_vault_purge_protection = true
enable_strict_network_acls = true

tags = {
  CostCenter = "Production-Ops"
  SLA        = "99.99"
}
