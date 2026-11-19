output "vnet_id" {
  description = "Virtual Network ID."
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  description = "Map of created subnet IDs."
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

output "vm_private_ips" {
  description = "Private IP addresses of deployed VMs."
  value       = azurerm_network_interface.vm_nic[*].private_ip_address
}

output "storage_account_id" {
  description = "Storage Account ID."
  value       = azurerm_storage_account.storage.id
}

output "key_vault_uri" {
  description = "Key Vault URI."
  value       = azurerm_key_vault.kv.vault_uri
}
