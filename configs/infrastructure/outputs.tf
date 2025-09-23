# Outputs for the infrastructure
# This file contains all output values from the Terraform configuration

output "vinegar_test_bucket_name" {
  description = "The name of the vinegar test bucket"
  value       = aws_s3_bucket.vinegar_test_bucket.id
}

output "vinegar_test_bucket_arn" {
  description = "The ARN of the vinegar test bucket"
  value       = aws_s3_bucket.vinegar_test_bucket.arn
}