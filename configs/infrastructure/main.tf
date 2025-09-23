# Generate random suffix for bucket name uniqueness
resource "random_id" "phoenix_bucket_suffix" {
  byte_length = 4
}

# Create S3 bucket for phoenix testing
resource "aws_s3_bucket" "phoenix_test_bucket" {
  bucket = var.bucket_name

  tags = merge(var.common_tags, {
    Name        = "${var.phoenix_bucket_name}-${random_id.phoenix_bucket_suffix.hex}"
    Purpose     = "Testing"
    Environment = var.environment
    Component   = "Storage"
  })
}

# Enable versioning for data protection
resource "aws_s3_bucket_versioning" "phoenix_test_bucket_versioning" {
  bucket = aws_s3_bucket.phoenix_test_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "phoenix_test_bucket_encryption" {
  bucket = aws_s3_bucket.phoenix_test_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Block all public access for security
resource "aws_s3_bucket_public_access_block" "phoenix_test_bucket_public_access_block" {
  bucket = aws_s3_bucket.phoenix_test_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Add lifecycle rules for cost optimization
resource "aws_s3_bucket_lifecycle_configuration" "phoenix_test_bucket_lifecycle" {
  bucket = aws_s3_bucket.phoenix_test_bucket.id

  rule {
    id     = "phoenix-test-lifecycle"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    noncurrent_version_transition {
      noncurrent_days = 60
      storage_class   = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    expiration {
      days = 365
    }
  }
}