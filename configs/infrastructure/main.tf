# Generate random suffix for bucket name uniqueness
resource "random_id" "prompt_bucket_suffix" {
  byte_length = 4
}

# Create S3 bucket for prompt testing
resource "aws_s3_bucket" "prompt_test_bucket" {
  bucket = var.bucket_name

  tags = merge(var.common_tags, {
    Name        = "${var.prompt_bucket_name}-${random_id.prompt_bucket_suffix.hex}"
    Purpose     = "Testing"
    Environment = var.environment
    Component   = "Storage"
  })
}

# Enable versioning for data protection
resource "aws_s3_bucket_versioning" "prompt_test_bucket_versioning" {
  bucket = aws_s3_bucket.prompt_test_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "prompt_test_bucket_encryption" {
  bucket = aws_s3_bucket.prompt_test_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Block all public access for security
resource "aws_s3_bucket_public_access_block" "prompt_test_bucket_public_access_block" {
  bucket = aws_s3_bucket.prompt_test_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}