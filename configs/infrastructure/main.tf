# Configure AWS Provider (no region needed for S3 as it's a global service)
provider "aws" {}

# Create S3 Bucket
resource "aws_s3_bucket" "astro_tourism_bucket" {
  bucket = "astro-tourism"

  tags = {
    Name        = "astro-tourism"
    Environment = "production"
    Purpose     = "Tourism Content"
    Managed_by  = "Terraform"
    Created_at  = timestamp()
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "astro_tourism_versioning" {
  bucket = aws_s3_bucket.astro_tourism_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "astro_tourism_encryption" {
  bucket = aws_s3_bucket.astro_tourism_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "astro_tourism_public_access_block" {
  bucket = aws_s3_bucket.astro_tourism_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable access logging
resource "aws_s3_bucket_logging" "astro_tourism_logging" {
  bucket = aws_s3_bucket.astro_tourism_bucket.id

  target_bucket = aws_s3_bucket.astro_tourism_bucket.id
  target_prefix = "access-logs/"
}

# Add lifecycle rules for content management
resource "aws_s3_bucket_lifecycle_configuration" "astro_tourism_lifecycle" {
  bucket = aws_s3_bucket.astro_tourism_bucket.id

  rule {
    id     = "content_lifecycle"
    status = "Enabled"

    # Move infrequently accessed content to cheaper storage
    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    # Archive older content
    transition {
      days          = 180
      storage_class = "GLACIER"
    }

    # Clean up old versions
    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

# Add CORS configuration for web access
resource "aws_s3_bucket_cors_configuration" "astro_tourism_cors" {
  bucket = aws_s3_bucket.astro_tourism_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"] # Consider restricting this to specific domains in production
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

# Output the bucket details
output "bucket_name" {
  value       = aws_s3_bucket.astro_tourism_bucket.id
  description = "The name of the bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.astro_tourism_bucket.arn
  description = "The ARN of the bucket"
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.astro_tourism_bucket.bucket_domain_name
  description = "The bucket domain name"
}

output "bucket_regional_domain_name" {
  value       = aws_s3_bucket.astro_tourism_bucket.bucket_regional_domain_name
  description = "The bucket region-specific domain name"
}