# Technical Interview Preparation: Multi-Environment Terraform Architecture

Interview questions and answers focused on DRY principles, multi-environment scaling, and infrastructure drift management.

---

## 1. 2-Minute Architecture Pitch

> "In this project, I architected an enterprise multi-environment infrastructure automation platform managing Development, QA, and Production from a single, unified Terraform codebase.
>
> To follow the DRY (Don't Repeat Yourself) principle, I engineered a parameterized workload module that dynamically provisions VNets, subnets using `for_each`, NSGs with dynamic blocks, and tiered compute pools. Environment configurations are driven by discrete variable files (`dev.tfvars`, `qa.tfvars`, `prod.tfvars`) and isolated remote state backends. In our Azure DevOps pipeline, promotion follows a gated path: every change auto-applies to Dev and runs smoke tests, halts for QA sign-off, runs integration suites, and requires formal CAB approval before applying to Production. Finally, an automated nightly pipeline runs drift detection using `terraform plan -detailed-exitcode` to safeguard production against out-of-band manual changes."

---

## 2. Key Technical Questions & Answers

### Q1: Why choose directory/variable-based environment isolation over Terraform Workspaces?
**Answer:**
While Terraform Workspaces are useful for testing identical, short-lived branch environments, enterprise architectures require strict blast-radius isolation. Workspaces share the same backend storage account and access credentials, creating a risk where an engineer could accidentally run commands against production. With directory/variable-based isolation, Dev, QA, and Prod have dedicated state files, distinct Azure credentials, and separate subscription scopes.

### Q2: How do you use `dynamic` blocks and `for_each` to create reusable infrastructure?
**Answer:**
Instead of hardcoding individual NSG rules or subnet definitions, we pass maps of objects. Using `for_each` on subnets allows each environment to declare different subnet CIDRs and counts without modifying root HCL. Dynamic blocks in `azurerm_network_security_group` iterate over variable rule lists, allowing dev to permit debugging ports like port 22 while production strictly restricts ingress to port 443.

### Q3: How does your pipeline detect and remediate infrastructure drift?
**Answer:**
We schedule a nightly Azure DevOps pipeline that initializes the production backend and executes `terraform plan -detailed-exitcode`. In Terraform, an exit code of 0 indicates zero changes, 1 indicates execution error, and 2 indicates drift (differences found). When code 2 is returned, the pipeline emits a high-priority alert. We then inspect the diff and either reconcile by applying the declared code or backport legitimate hotfixes into Git.

### Q4: How do you prevent resource naming collisions across environments in the same Azure tenant?
**Answer:**
We enforce standardized naming conventions in `locals.tf`, prefixing resources with project name and environment (`rg-fw-multi-dev`, `rg-fw-multi-prod`). For globally unique Azure resources like Storage Accounts and Key Vaults, we combine truncated project names, environment tags, and deterministic or pseudorandom suffixes (`stfwmultidev9a2f1`).
