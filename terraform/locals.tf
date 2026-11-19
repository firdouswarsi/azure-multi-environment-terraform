locals {
  environment_normalized = lower(var.environment)
  base_name              = "${var.project_name}-${local.environment_normalized}"

  # Default tags merged with environment-specific tags
  common_tags = merge(
    var.tags,
    {
      Environment = local.environment_normalized
      ManagedBy   = "Terraform"
      Project     = var.project_name
      Owner       = "Firdous Warsi"
    }
  )

  # Computed configuration based on environment tier
  is_production = local.environment_normalized == "prod"
}
