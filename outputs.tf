output "source_bucket_name" {
  description = "Name of the source S3 bucket"
  value       = try(aws_s3_bucket.source.bucket, "Not created")
}

output "backup_bucket_name" {
  description = "Name of the backup S3 bucket"
  value       = try(aws_s3_bucket.backup.bucket, "Not created")
}

output "lambda_function_arn" {
  description = "ARN of the backup Lambda function"
  value       = try(aws_lambda_function.backup.arn, "Not created")
}

output "lambda_iam_role" {
  description = "IAM role used by Lambda"
  value       = try(aws_iam_role.backup_lambda.arn, "Not created")
}

# For debugging/verification
output "s3_event_notification" {
  description = "S3 event notification configuration ID"
  value       = try(aws_s3_bucket_notification.source_trigger.id, "Not configured")
}
