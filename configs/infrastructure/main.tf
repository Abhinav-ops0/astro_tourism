# Add to configs/infrastructure/main.tf

# Create new S3 bucket for Terraform PR testing
resource "aws_s3_bucket" "terraform_pr_test_bucket" {
  bucket = var.bucket_name

  tags = merge(var.tags, {
    Name = "new-terraform-test-pr"
    Purpose = "Terraform PR Testing"
    Environment = var.environment
    Component = "PR"
  })
}

# Enable versioning
resource "aws_s3_bucket_versioning" "terraform_pr_test_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_pr_test_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_pr_test_bucket_encryption" {
  bucket = aws_s3_bucket.terraform_pr_test_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "terraform_pr_test_bucket_public_access_block" {
  bucket = aws_s3_bucket.terraform_pr_test_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable access logging
resource "aws_s3_bucket_logging" "terraform_pr_test_bucket_logging" {
  bucket = aws_s3_bucket.terraform_pr_test_bucket.id

  target_bucket = aws_s3_bucket.terraform_pr_test_bucket.id
  target_prefix = "access-logs/"
}

# Add lifecycle rules
resource "aws_s3_bucket_lifecycle_configuration" "terraform_pr_test_bucket_lifecycle" {
  bucket = aws_s3_bucket.terraform_pr_test_bucket.id

  rule {
    id     = "terraform_pr_test_lifecycle"
    status = "Enabled"

    # Move files to STANDARD_IA after 30 days
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    # Move old versions to Glacier after 60 days
    noncurrent_version_transition {
      noncurrent_days = 60
      storage_class   = "GLACIER"
    }

    # Delete old versions after 90 days
    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    # Clean up incomplete multipart uploads
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    # Delete test files after 180 days
    expiration {
      days = 180
    }
  }
}

# Add intelligent tiering for cost optimization
resource "aws_s3_bucket_intelligent_tiering_configuration" "terraform_pr_test_bucket_tiering" {
  bucket = aws_s3_bucket.terraform_pr_test_bucket.id
  name   = "TerraformPRTiering"

  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 90
  }

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 180
  }

  # Filter to exclude small objects where tiering wouldn't be cost-effective
  filter {
    min_object_size = 128000  # 128KB
  }
}

# Add CORS configuration for PR testing functionality
resource "aws_s3_bucket_cors_configuration" "terraform_pr_test_bucket_cors" {
  bucket = aws_s3_bucket.terraform_pr_test_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
    allowed_origins = ["*"]  # Restrict this to specific domains in production
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}