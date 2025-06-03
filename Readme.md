# AWS S3 Automated Backup System  
Terraform project that creates an event-driven backup pipeline between S3 buckets using Lambda.  

## Features  
- **Infrastructure-as-Code**: Deploys S3 buckets, Lambda, and IAM roles via Terraform.  
- **Event-Driven**: Triggers backups on `s3:ObjectCreated` events.  
- **Scalable Design**: Variables/outputs allow customization (e.g., bucket names, regions).  

## Customization  
Override defaults in `variables.tf` (e.g., `terraform apply -var="lambda_timeout=60"`).

## Usage  
1. Initialize Terraform:  
   ```bash  
   terraform init  