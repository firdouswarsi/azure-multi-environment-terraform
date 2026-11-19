# Troubleshooting Guide: Multi-Environment Terraform

Operational procedures for addressing multi-environment deployment issues and state drift.

---

## 1. Environment State Crossover or Backend Key Collision

### Symptoms:
Running `terraform plan` for QA displays changes intended for Dev or prompts for destruction of existing resources.

### Cause:
Terraform CLI cached the previous backend initialization and did not reconfigure when switching environments.

### Resolution:
Always use the `-reconfigure` flag when switching backend state files:
```bash
terraform init -reconfigure -backend-config="environments/<target-env>/backend-<target-env>.tfvars"
```

---

## 2. Infrastructure Drift Detected (`Exit Code 2`)

### Symptoms:
The nightly drift detection pipeline flags a warning: `Drift detected in Production infrastructure!`.

### Cause:
An engineer modified an NSG rule, added a tag, or resized a disk directly via the Azure Portal or Azure CLI outside of Terraform.

### Resolution:
1. Run drift detection script locally to review the exact diff:
   ```bash
   ./scripts/drift-detection.sh prod
   ```
2. If the manual change was an emergency hotfix that should be preserved:
   - Update `environments/prod/prod.tfvars` or root configuration to reflect the change.
   - Run a clean `terraform plan` to verify zero diff.
3. If the change was unauthorized:
   - Execute `terraform apply -var-file="environments/prod/prod.tfvars"` to reconcile Azure resources back to the declared Terraform baseline.
