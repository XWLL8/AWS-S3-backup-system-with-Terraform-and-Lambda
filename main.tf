provider "aws" {
  region = var.aws_region  # Now references variable
}

# Random suffix for unique bucket names
resource "random_id" "suffix" {
  byte_length = 4
}

# Source Bucket (with versioning/encryption)
resource "aws_s3_bucket" "source" {
  bucket = "${var.source_bucket_prefix}-${random_id.suffix.hex}"  # Uses variable
  tags   = var.tags  # Standardized tagging
}

resource "aws_s3_bucket_versioning" "source" {
  bucket = aws_s3_bucket.source.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "source" {
  bucket = aws_s3_bucket.source.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Backup Bucket (with lifecycle policy)
resource "aws_s3_bucket" "backup" {
  bucket = "${var.backup_bucket_prefix}-${random_id.suffix.hex}"  # Uses variable
  tags   = var.tags
}

resource "aws_s3_bucket_lifecycle_configuration" "backup" {
  bucket = aws_s3_bucket.backup.id
  rule {
    id     = "glacier-rule"
    status = "Enabled"
    transition {
      days          = var.backup_retention_days  # Now configurable
      storage_class = "GLACIER_IR"
    }
  }
}

# Lambda IAM Role
resource "aws_iam_role" "backup_lambda" {
  name = "S3BackupLambdaRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy" "s3_access" {
  name = "S3BackupAccess"
  role = aws_iam_role.backup_lambda.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObject"]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.source.arn}/*"
      },
      {
        Action   = ["s3:PutObject"]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.backup.arn}/*"
      },
      {
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Lambda Function
resource "aws_lambda_function" "backup" {
  function_name = "S3BackupLambda"
  runtime       = "python3.12"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.backup_lambda.arn
  timeout       = var.lambda_timeout  # Now configurable
  filename      = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
  tags          = var.tags

  environment {
    variables = {
      SOURCE_BUCKET = aws_s3_bucket.source.bucket
      BACKUP_BUCKET = aws_s3_bucket.backup.bucket
    }
  }
}

# S3 Event Trigger
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.backup.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.source.arn
}

resource "aws_s3_bucket_notification" "source_trigger" {
  bucket = aws_s3_bucket.source.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.backup.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_lambda_permission.allow_s3]
}

