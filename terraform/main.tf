resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.base_name}"
  location = var.location
  tags     = local.common_tags
}

module "workload" {
  source                     = "./modules/workload_environment"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  environment                = local.environment_normalized
  vnet_name                  = "vnet-${local.base_name}"
  vnet_address_space         = var.vnet_address_space
  subnets                    = var.subnets
  workload_subnet_name       = var.workload_subnet_name
  nsg_rules                  = var.nsg_rules
  vm_count                   = var.vm_count
  vm_size                    = var.vm_size
  admin_username             = var.admin_username
  ssh_public_key             = var.ssh_public_key
  os_disk_type               = var.os_disk_type
  os_disk_size_gb            = var.os_disk_size_gb
  storage_account_name       = "st${replace(local.base_name, "-", "")}${random_string.suffix.result}"
  storage_replication_type   = var.storage_replication_type
  key_vault_name             = "kv-${substr(local.base_name, 0, 10)}-${random_string.suffix.result}"
  key_vault_sku              = var.key_vault_sku
  key_vault_retention_days   = var.key_vault_retention_days
  key_vault_purge_protection = var.key_vault_purge_protection
  enable_strict_network_acls = var.enable_strict_network_acls
  tags                       = local.common_tags
}
