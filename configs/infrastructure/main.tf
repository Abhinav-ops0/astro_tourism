# Configure AWS Provider
provider "aws" {}

# Create S3 Bucket
resource "aws_s3_bucket" "astro_tour_bucket" {
  bucket = "astro-tour-mod-123"

  tags = {
    Name        = "astro-tour-mod-123"
    Environment = "production"
    Managed_by  = "Terraform"
    Created_at  = timestamp()
    Project     = "Astro Tour"
  }
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

# Add lifecycle rules
resource "aws_s3_bucket_lifecycle_configuration" "astro_tour_bucket_lifecycle" {
  bucket = aws_s3_bucket.astro_tour_bucket.id

  rule {
    id     = "cost_optimization"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 180
      storage_class = "GLACIER"
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

# Add bucket policy to enforce SSL
resource "aws_s3_bucket_policy" "astro_tour_bucket_policy" {
  bucket = aws_s3_bucket.astro_tour_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "EnforceSSLOnly"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.astro_tour_bucket.arn,
          "${aws_s3_bucket.astro_tour_bucket.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

# Output the bucket details