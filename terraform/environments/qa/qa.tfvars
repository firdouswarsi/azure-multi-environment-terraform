project_name       = "fw-multi"
environment        = "qa"
location           = "eastus"
vnet_address_space = ["10.20.0.0/16"]

subnets = {
  snet-workload = { prefix = "10.20.1.0/24" }
  snet-data     = { prefix = "10.20.2.0/24" }
}

workload_subnet_name = "snet-workload"

nsg_rules = [
  {
    name                       = "Allow-Internal-Workload-QA"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }
]

vm_count        = 2
vm_size         = "Standard_B2s"
admin_username  = "azureuser"
ssh_public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3... qa-key"
os_disk_type    = "StandardSSD_LRS"
os_disk_size_gb = 64

storage_replication_type   = "ZRS"
key_vault_sku              = "standard"
key_vault_retention_days   = 14
key_vault_purge_protection = false
enable_strict_network_acls = false

tags = {
  CostCenter = "Engineering-QA"
}
