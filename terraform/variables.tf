variable "project_name" {
  description = "Project name prefix."
  type        = string
  default     = "fw-multi"
}

variable "environment" {
  description = "Target environment (dev, qa, prod)."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "eastus"
}

variable "vnet_address_space" {
  description = "VNet CIDR address space."
  type        = list(string)
}

variable "subnets" {
  description = "Subnets map with CIDR prefixes."
  type = map(object({
    prefix = string
  }))
}

variable "workload_subnet_name" {
  description = "Subnet name hosting VMs."
  type        = string
  default     = "snet-workload"
}

variable "nsg_rules" {
  description = "Dynamic security rules for NSG."
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}

variable "vm_count" {
  description = "Number of VM instances."
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "Virtual machine SKU."
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "VM Admin username."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key for VM login."
  type        = string
}

variable "os_disk_type" {
  description = "OS disk type."
  type        = string
  default     = "Standard_LRS"
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB."
  type        = number
  default     = 32
}

variable "storage_replication_type" {
  description = "Storage replication (LRS, ZRS, GRS)."
  type        = string
  default     = "LRS"
}

variable "key_vault_sku" {
  description = "Key Vault SKU (standard or premium)."
  type        = string
  default     = "standard"
}

variable "key_vault_retention_days" {
  description = "Key Vault soft delete retention days."
  type        = number
  default     = 7
}

variable "key_vault_purge_protection" {
  description = "Enable Key Vault purge protection."
  type        = bool
  default     = false
}

variable "enable_strict_network_acls" {
  description = "Enforce strict network ACLs on Key Vault."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = {}
}
