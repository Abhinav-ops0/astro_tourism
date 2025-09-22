# Variables for the infrastructure
# This file contains all input variables for the Terraform configuration

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "new-pr-editor-changes"
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