# Variables for the infrastructure
# This file contains all input variables for the Terraform configuration

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "test-new-flow-123454"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "Test"
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "production"
    Managed_by  = "Terraform"
    Created_at  = "2025-01-01"
  }
}