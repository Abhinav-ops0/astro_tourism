# Add to configs/infrastructure/main.tf

# Create new S3 bucket for vinegar testing
resource "aws_s3_bucket" "vinegar_test_bucket" {
  bucket = var.bucket_name

  tags = merge(var.tags, {
    Name        = "vinegar-test-1"
    Purpose     = "Testing"
    Environment = var.environment
    Component   = "Storage"
  })
}

# Enable versioning for data protection
resource "aws_s3_bucket_versioning" "vinegar_test_bucket_versioning" {
  bucket = aws_s3_bucket.vinegar_test_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "vinegar_test_bucket_encryption" {
  bucket = aws_s3_bucket.vinegar_test_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Block all public access for security
resource "aws_s3_bucket_public_access_block" "vinegar_test_bucket_public_access_block" {
  bucket = aws_s3_bucket.vinegar_test_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable access logging
resource "aws_s3_bucket_logging" "vinegar_test_bucket_logging" {
  bucket = aws_s3_bucket.vinegar_test_bucket.id

  target_bucket = aws_s3_bucket.vinegar_test_bucket.id
  target_prefix = "access-logs/"
}

# Add lifecycle rules for cost optimization
resource "aws_s3_bucket_lifecycle_configuration" "vinegar_test_bucket_lifecycle" {
  bucket = aws_s3_bucket.vinegar_test_bucket.id

  rule {
    id     = "vinegar_test_lifecycle"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
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
      days = 180
    }
  }
}

# Add intelligent tiering configuration
resource "aws_s3_bucket_intelligent_tiering_configuration" "vinegar_test_bucket_tiering" {
  bucket = aws_s3_bucket.vinegar_test_bucket.id
  name   = "VinegarTestingTiering"

  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 90
  }

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 180
  }

  filter {
    prefix = "data/"
  }
}

# Add outputs for the bucket