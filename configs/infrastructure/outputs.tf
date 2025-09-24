# Outputs for the infrastructure
# This file contains all output values from the Terraform configuration

output "help_test_bucket_name" {
  description = "The name of the help test bucket"
  value       = aws_s3_bucket.help_test_bucket.id
}

output "help_test_bucket_arn" {
  description = "The ARN of the help test bucket"
  value       = aws_s3_bucket.help_test_bucket.arn
}