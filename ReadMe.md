# 🌐 Site-to-Site VPN Between AWS and Azure (Terraform)

This project sets up a **highly available, IPsec-based Site-to-Site VPN** tunnel between an **AWS VPC** and an **Azure Virtual Network** using **Terraform**.

---

## 🧰 Tools & Services Used

- **Terraform** (IaC)
- **Azure** (Virtual Network, VPN Gateway)
- **AWS** (VPC, VPN Gateway, Customer Gateway)
- **IPSec** VPN with shared key

---

## 📁 Project Structure

vpn-project/ ├── main.tf # All infrastructure logic ├── variables.tf # Input variables ├── terraform.tfvars # Your environment-specific values ├── outputs.tf # Key outputs after deployment
---

## 🚀 How to Use

### 1. 🛠️ Prerequisites

- [Terraform installed](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- AWS credentials configured (`~/.aws/credentials`)
- Azure credentials authenticated (via `az login`)

---

### 2. 📦 Initialize

```bash
terraform init

terraform plan

terraform apply
