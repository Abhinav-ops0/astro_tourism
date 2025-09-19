# Add to configs/infrastructure/main.tf

# Create new S3 bucket for test flow
resource "aws_s3_bucket" "flow_test_bucket" {
  bucket = var.bucket_name

  tags = merge(var.tags, {
    Name = "test-new-flow-123454"
    Purpose = "Test flow storage"
    Environment = var.environment
  })
}

# Enable versioning
resource "aws_s3_bucket_versioning" "flow_test_bucket_versioning" {
  bucket = aws_s3_bucket.flow_test_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "flow_test_bucket_encryption" {
  bucket = aws_s3_bucket.flow_test_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "flow_test_bucket_public_access_block" {
  bucket = aws_s3_bucket.flow_test_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable access logging
resource "aws_s3_bucket_logging" "flow_test_bucket_logging" {
  bucket = aws_s3_bucket.flow_test_bucket.id

  target_bucket = aws_s3_bucket.flow_test_bucket.id
  target_prefix = "access-logs/"
}

# Add lifecycle rules
resource "aws_s3_bucket_lifecycle_configuration" "flow_test_bucket_lifecycle" {
  bucket = aws_s3_bucket.flow_test_bucket.id

  rule {
    id     = "test_flow_management"
    status = "Enabled"

    # Move non-current versions to glacier after 30 days
    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "GLACIER"
    }

    # Delete non-current versions after 60 days
    noncurrent_version_expiration {
      noncurrent_days = 60
    }

    # Clean up incomplete multipart uploads
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    # Expire current versions after 90 days
    expiration {
      days = 90
    }
  }
}

# Add intelligent tiering
resource "aws_s3_bucket_intelligent_tiering_configuration" "flow_test_bucket_tiering" {
  bucket = aws_s3_bucket.flow_test_bucket.id
  name   = "TestFlowTiering"

  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 60
  }

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 120
  }
}