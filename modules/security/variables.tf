variable "name_prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "security_account_id" {
  description = "AWS account ID for the delegated security account"
  type        = string
}

variable "log_archive_bucket_name" {
  description = "S3 bucket name in log archive account for CloudTrail"
  type        = string
}

variable "config_aggregator_role_arn" {
  description = "IAM role ARN for Config aggregator"
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}
