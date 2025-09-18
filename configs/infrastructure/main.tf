# Configure AWS Provider
provider "aws" {}

# Create S3 Bucket
resource "aws_s3_bucket" "astro_tour_bucket" {
  bucket = var.bucket_name

  tags = var.tags
}

# Enable versioning
resource "aws_s3_bucket_versioning" "astro_tour_bucket_versioning" {
  bucket = aws_s3_bucket.astro_tour_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "astro_tour_bucket_encryption" {
  bucket = aws_s3_bucket.astro_tour_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "astro_tour_bucket_public_access_block" {
  bucket = aws_s3_bucket.astro_tour_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable access logging
resource "aws_s3_bucket_logging" "astro_tour_bucket_logging" {
  bucket = aws_s3_bucket.astro_tour_bucket.id

  target_bucket = aws_s3_bucket.astro_tour_bucket.id
  target_prefix = "access-logs/"
}

# Add intelligent tiering for cost optimization
resource "aws_s3_bucket_intelligent_tiering_configuration" "astro_tour_bucket_tiering" {
  bucket = aws_s3_bucket.astro_tour_bucket.id
  name   = "EntireBucket"

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 180
  }

  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 90
  }
}

# Add lifecycle rules
resource "aws_s3_bucket_lifecycle_configuration" "astro_tour_bucket_lifecycle" {
  bucket = aws_s3_bucket.astro_tour_bucket.id

  rule {
    id     = "cleanup_and_archive"
    status = "Enabled"

    # Move non-current versions to glacier after 90 days
    noncurrent_version_transition {
      noncurrent_days = 90
      storage_class   = "GLACIER"
    }

    # Delete non-current versions after 365 days
    noncurrent_version_expiration {
      noncurrent_days = 365
    }

    # Clean up incomplete multipart uploads
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# Output the bucket details