variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "me-central-1"  # Bahrain region (change if needed)
}

variable "source_bucket_prefix" {
  description = "Prefix for the source S3 bucket name (avoid hardcoding)"
  type        = string
  default     = "my-source-bkt"
}

variable "backup_bucket_prefix" {
  description = "Prefix for the backup S3 bucket name"
  type        = string
  default     = "my-backup-bkt"
}

variable "lambda_timeout" {
  description = "Timeout for Lambda function in seconds"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Standard tags for all resources"
  type        = map(string)
  default     = {
    Project     = "S3Backup"
    Environment = "Dev"
    Terraform   = "true"
  }
}