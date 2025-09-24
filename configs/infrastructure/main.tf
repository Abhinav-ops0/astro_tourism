# S3 bucket for help testing
resource "aws_s3_bucket" "help_test_bucket" {
  bucket = var.bucket_name

  tags = var.tags
}

# Enable versioning
resource "aws_s3_bucket_versioning" "help_test_bucket_versioning" {
  bucket = aws_s3_bucket.help_test_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "help_test_bucket_encryption" {
  bucket = aws_s3_bucket.help_test_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "help_test_bucket_public_access_block" {
  bucket = aws_s3_bucket.help_test_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Output the bucket name and ARN