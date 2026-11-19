output "resource_group_name" {
  description = "Target Resource Group Name."
  value       = azurerm_resource_group.rg.name
}

output "vnet_id" {
  description = "Virtual Network ID."
  value       = module.workload.vnet_id
}

output "subnet_ids" {
  description = "Subnet Resource IDs."
  value       = module.workload.subnet_ids
}

output "vm_private_ips" {
  description = "Private IP addresses of deployed virtual machines."
  value       = module.workload.vm_private_ips
}

output "storage_account_id" {
  description = "Storage account ID."
  value       = module.workload.storage_account_id
}

output "key_vault_uri" {
  description = "Key Vault URI."
  value       = module.workload.key_vault_uri
}
