#!/usr/bin/env bash
# Validate all environment variable files and configurations
set -e

echo "=== [1/4] Checking Canonical Formatting ==="
terraform -chdir=terraform fmt -check -recursive

echo "=== [2/4] Initializing Terraform for Validation ==="
terraform -chdir=terraform init -backend=false

echo "=== [3/4] Validating Syntax ==="
terraform -chdir=terraform validate

echo "=== [4/4] Verifying Environment Variable Files ==="
for env in dev qa prod; do
    if [ -f "terraform/environments/$env/$env.tfvars" ]; then
        echo "[OK] Environment config verified: $env.tfvars"
    else
        echo "[FAIL] Missing config: $env.tfvars"
        exit 1
    fi
done

echo "=== All environment validations completed successfully ==="
