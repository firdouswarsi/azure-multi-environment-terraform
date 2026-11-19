#!/usr/bin/env bash
# Automated Terraform Drift Detection Script
set -e

ENV=${1:-prod}
echo "=== Running Terraform Drift Detection for [$ENV] ==="

cd terraform
terraform init -reconfigure -backend-config="environments/$ENV/backend-$ENV.tfvars"

set +e
terraform plan -var-file="environments/$ENV/$ENV.tfvars" -detailed-exitcode -no-color > drift_report.txt
EXIT_CODE=$?
set -e

if [ $EXIT_CODE -eq 0 ]; then
    echo "[SYNC] No drift detected in $ENV. Cloud state matches Terraform configuration."
elif [ $EXIT_CODE -eq 2 ]; then
    echo "[DRIFT ALERT] Infrastructure drift detected in $ENV!"
    cat drift_report.txt
    exit 2
else
    echo "[ERROR] Terraform plan failed with code $EXIT_CODE."
    exit 1
fi
