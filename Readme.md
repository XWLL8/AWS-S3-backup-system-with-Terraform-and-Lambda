# 🚀 AWS S3 Automated Backup System with Terraform and Lambda

[![Terraform Version](https://img.shields.io/badge/terraform-%3E%3D1.3.0-blue.svg)](https://terraform.io)
[![Python Version](https://img.shields.io/badge/python-3.12+-yellow.svg)](https://python.org)

A production-ready infrastructure solution that automatically backs up files between S3 buckets using event-driven Lambda functions.

## ✨ Key Features

| Feature | Description |
|---------|-------------|
| **Infrastructure-as-Code** | Fully deployable with Terraform (AWS resources + permissions) |
| **Event-Driven Architecture** | Instant backups triggered by S3 uploads via Lambda |
| **Security Best Practices** | IAM least-privilege roles, S3 encryption enabled |
| **Cost Optimized** | Lifecycle rules to transition backups to Glacier after 30 days |
| **Customizable** | Configure regions, bucket names, and retention periods |

## 🛠️ Technical Stack
- **AWS Services**: S3, Lambda, IAM, CloudWatch
- **Languages**: Terraform (HCL), Python 3.12
- **Tools**: AWS CLI, Git

## 🚦 Getting Started

### Prerequisites
- AWS account with CLI configured
- Terraform 1.3.0+
- Python 3.12 (for Lambda)

### Deployment
```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Deploy (will create S3 buckets + Lambda)
terraform apply
