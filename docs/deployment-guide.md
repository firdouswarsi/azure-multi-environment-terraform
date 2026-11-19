# Enterprise Deployment Guide: Multi-Environment Infrastructure

This guide details the procedure for provisioning and promoting cloud infrastructure across Development, QA/Staging, and Production environments using Terraform and Azure DevOps.

---

## 1. Remote State Configuration

Each environment stores its state file independently within Azure Blob Storage:
- **Dev**: `multi-env-dev.terraform.tfstate`
- **QA**: `multi-env-qa.terraform.tfstate`
- **Prod**: `multi-env-prod.terraform.tfstate`

Create the prerequisite storage container:
```bash
az group create --name rg-terraform-state --location eastus
az storage account create --name sttfstateenterprise01 --resource-group rg-terraform-state --sku Standard_LRS
az storage container create --name tfstate --account-name sttfstateenterprise01
```

---

## 2. Local Manual Deployment

### Provisioning Dev:
```bash
cd terraform
terraform init -reconfigure -backend-config="environments/dev/backend-dev.tfvars"
terraform plan -var-file="environments/dev/dev.tfvars" -out=tfplan-dev
terraform apply tfplan-dev
```

### Provisioning QA:
```bash
terraform init -reconfigure -backend-config="environments/qa/backend-qa.tfvars"
terraform plan -var-file="environments/qa/qa.tfvars" -out=tfplan-qa
terraform apply tfplan-qa
```

### Provisioning Production:
```bash
terraform init -reconfigure -backend-config="environments/prod/backend-prod.tfvars"
terraform plan -var-file="environments/prod/prod.tfvars" -out=tfplan-prod
terraform apply tfplan-prod
```

---

## 3. Automated Promotion Pipeline

The Azure DevOps pipeline enforces staged promotion:
1. **Merge to `main`**: Automatically triggers deployment to Dev.
2. **Automated Smoke Tests**: Validates VM health and network reachability.
3. **QA Approval Gate**: QA Lead reviews test metrics and approves promotion to QA.
4. **Integration Testing**: Automated integration tests execute against the QA environment.
5. **Production Approval Gate**: Change Advisory Board (CAB) reviews security scans and grants production apply sign-off.
6. **Nightly Drift Detection**: Scheduled cron pipeline scans production at 02:00 UTC and alerts on out-of-band changes.
