variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "environment" {
  description = "Target environment: dev, qa, prod."
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network."
  type        = string
}

variable "vnet_address_space" {
  description = "VNet CIDR address space."
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnets to create."
  type = map(object({
    prefix = string
  }))
}

variable "workload_subnet_name" {
  description = "Name of subnet hosting compute workloads."
  type        = string
  default     = "snet-workload"
}

variable "nsg_rules" {
  description = "List of dynamic security rules for NSG."
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
  description = "Number of VMs to provision in this environment."
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "SKU for virtual machines."
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for VM."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "Public SSH key for VM authentication."
  type        = string
}

variable "os_disk_type" {
  description = "OS Disk storage type (Standard_LRS, Premium_LRS)."
  type        = string
  default     = "Standard_LRS"
}

variable "os_disk_size_gb" {
  description = "OS Disk size in GB."
  type        = number
  default     = 32
}

variable "storage_account_name" {
  description = "Storage account name."
  type        = string
}

variable "storage_replication_type" {
  description = "Storage replication (LRS, ZRS, GRS)."
  type        = string
  default     = "LRS"
}

variable "key_vault_name" {
  description = "Key Vault name."
  type        = string
}

variable "key_vault_sku" {
  description = "Key Vault SKU (standard, premium)."
  type        = string
  default     = "standard"
}

variable "key_vault_retention_days" {
  description = "Soft delete retention days."
  type        = number
  default     = 7
}

variable "key_vault_purge_protection" {
  description = "Whether purge protection is enabled."
  type        = bool
  default     = false
}

variable "enable_strict_network_acls" {
  description = "Whether to deny default public access to Key Vault."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = {}
}
