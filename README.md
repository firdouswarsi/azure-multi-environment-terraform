# Multi-Environment Infrastructure Automation on Azure (Dev, QA, Prod)

[![Terraform](https://img.shields.io/badge/IaC-Terraform_v1.5+-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/Cloud-Microsoft_Azure-0078D4?logo=microsoftazure&logoColor=white)](https://azure.microsoft.com/)
[![Azure DevOps](https://img.shields.io/badge/CI%2FCD-Gated_Pipelines-2560E0?logo=azuredevops&logoColor=white)](https://dev.azure.com/)
[![Architecture](https://img.shields.io/badge/Pattern-DRY_Multi--Environment-success?logo=terraform&logoColor=white)](https://developer.hashicorp.com/terraform/language/modules)

An enterprise-grade **Multi-Environment Infrastructure Automation** solution provisioning Development, QA, and Production environments on Microsoft Azure from a single reusable Terraform codebase using the DRY (Don't Repeat Yourself) principle, environment variable files, isolated state locking, gated promotion pipelines, and automated drift detection.

---

## 1. Multi-Stage Gated Promotion Workflow

```mermaid
flowchart LR
    subgraph Trigger_Stage["Code Commit"]
        Commit["Git Push to main"]
    end

    subgraph Dev_Stage["Stage 1: Development Environment"]
        Commit --> Dev_Plan["Terraform Plan (dev.tfvars)"]
        Dev_Plan --> Dev_Apply["Auto-Apply to Dev"]
        Dev_Apply --> Dev_Test["Automated Smoke Tests"]
    end

    subgraph QA_Stage["Stage 2: QA / Staging Environment"]
        Dev_Test --> QA_Gate{"QA Approval Gate<br/>(QA Sign-off)"}
        QA_Gate -->|"Approved"| QA_Plan["Terraform Plan (qa.tfvars)"]
        QA_Plan --> QA_Apply["Deploy to QA"]
        QA_Apply --> QA_Integ["Automated Integration Tests"]
    end

    subgraph Prod_Stage["Stage 3: Production Environment"]
        QA_Integ --> Prod_Gate{"Production Approval Gate<br/>(CAB Sign-off)"}
        Prod_Gate -->|"Approved"| Prod_Plan["Terraform Plan (prod.tfvars)"]
        Prod_Plan --> Prod_Apply["Apply to Production (GRS / High Avail)"]
        Prod_Apply --> Prod_Monitor["Continuous Drift Monitoring"]
    end

    classDef triggerStyle fill:#0f172a,stroke:#38bdf8,stroke-width:2px,color:#ffffff;
    classDef devStyle fill:#064e3b,stroke:#34d399,stroke-width:1.5px,color:#ffffff;
    classDef qaStyle fill:#1e1b4b,stroke:#818cf8,stroke-width:1.5px,color:#ffffff;
    classDef prodStyle fill:#4c0519,stroke:#f43f5e,stroke-width:1.5px,color:#ffffff;
    classDef gateStyle fill:#78350f,stroke:#fbbf24,stroke-width:1.5px,color:#ffffff;

    class Commit triggerStyle;
    class Dev_Plan,Dev_Apply,Dev_Test devStyle;
    class QA_Gate,Prod_Gate gateStyle;
    class QA_Plan,QA_Apply,QA_Integ qaStyle;
    class Prod_Plan,Prod_Apply,Prod_Monitor prodStyle;
```

---

## 2. Environment Architecture Topology

```mermaid
flowchart TD
    subgraph Env_Dev["Development (dev)"]
        Dev_VNet["VNet: 10.10.0.0/16"]
        Dev_VM["1x Standard_B1s VM<br/>(Dev Workload)"]
        Dev_Storage["Storage: Standard_LRS"]
        Dev_KV["Key Vault (Standard)"]
        Dev_VNet --- Dev_VM
        Dev_VNet --- Dev_Storage
        Dev_VNet --- Dev_KV
    end

    subgraph Env_QA["QA / Staging (qa)"]
        QA_VNet["VNet: 10.20.0.0/16"]
        QA_VM["2x Standard_B2s VMs<br/>(Availability Set)"]
        QA_Storage["Storage: Standard_ZRS"]
        QA_KV["Key Vault (Standard)"]
        QA_VNet --- QA_VM
        QA_VNet --- QA_Storage
        QA_VNet --- QA_KV
    end

    subgraph Env_Prod["Production (prod)"]
        Prod_VNet["VNet: 10.30.0.0/16"]
        Prod_VM["4x Standard_D2s_v5 VMs<br/>(High Performance)"]
        Prod_Storage["Storage: Standard_GRS<br/>(Geo-Redundant)"]
        Prod_KV["Key Vault (Premium + Purge Protect)"]
        Prod_VNet --- Prod_VM
        Prod_VNet --- Prod_Storage
        Prod_VNet --- Prod_KV
    end

    classDef devBox fill:#022c22,stroke:#059669,stroke-width:1.5px,color:#ffffff;
    classDef qaBox fill:#172554,stroke:#2563eb,stroke-width:1.5px,color:#ffffff;
    classDef prodBox fill:#3f0713,stroke:#e11d48,stroke-width:2px,color:#ffffff;

    class Dev_VNet,Dev_VM,Dev_Storage,Dev_KV devBox;
    class QA_VNet,QA_VM,QA_Storage,QA_KV qaBox;
    class Prod_VNet,Prod_VM,Prod_Storage,Prod_KV prodBox;
```

---

## 3. Environment Specifications

| Environment | VNet CIDR | VM Count | VM SKU | Storage Tier | Key Vault SKU |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Development** (`dev`) | `10.10.0.0/16` | 1 | `Standard_B1s` | `Standard_LRS` | `standard` |
| **QA / Staging** (`qa`) | `10.20.0.0/16` | 2 | `Standard_B2s` | `Standard_ZRS` | `standard` |
| **Production** (`prod`) | `10.30.0.0/16` | 4 | `Standard_D2s_v5` | `Standard_GRS` | `premium` |

---

## 4. Repository Structure

```
azure-multi-environment-terraform/
├── architecture/
│   └── architecture.md            # Topology, promotion model and matrix
├── docs/
│   ├── deployment-guide.md        # Step-by-step promotion instructions
│   ├── troubleshooting.md         # State crossover and drift resolution
│   └── interview-questions.md     # Architectural walkthroughs & Q&A
├── pipelines/
│   └── azure-pipelines.yml        # Gated multi-stage promotion pipeline
├── scripts/
│   ├── drift-detection.sh         # CLI automated drift scanner
│   └── validate-all-envs.sh       # Multi-environment validation
└── terraform/
    ├── locals.tf                  # Local values and dynamic naming
    ├── main.tf                    # Root environment composition
    ├── outputs.tf                 # Output declarations
    ├── providers.tf               # Providers and dynamic backend definition
    ├── variables.tf               # Input variable declarations
    ├── environments/
    │   ├── dev/
    │   │   ├── backend-dev.tfvars # Dev remote state config
    │   │   └── dev.tfvars         # Dev parameters
    │   ├── qa/
    │   │   ├── backend-qa.tfvars  # QA remote state config
    │   │   └── qa.tfvars          # QA parameters
    │   └── prod/
    │       ├── backend-prod.tfvars# Prod remote state config
    │       └── prod.tfvars        # Prod parameters
    └── modules/
        └── workload_environment/  # Reusable environment module (VNet, VM, KV, Storage)
```

---

## 5. Quickstart

### Deploy to Development:
```bash
cd terraform
terraform init -reconfigure -backend-config="environments/dev/backend-dev.tfvars"
terraform plan -var-file="environments/dev/dev.tfvars" -out=tfplan-dev
terraform apply tfplan-dev
```

### Run Drift Detection on Production:
```bash
./scripts/drift-detection.sh prod
```

---

## 6. Author

**Firdous Warsi** — *Azure DevOps Engineer*  
- GitHub: [@firdouswarsi](https://github.com/firdouswarsi)
- Specialized in Azure Cloud Architecture, Infrastructure as Code & Multi-Environment Automation.
