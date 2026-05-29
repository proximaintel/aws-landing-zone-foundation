resource "aws_guardduty_organization_admin_account" "main" {
  admin_account_id = var.security_account_id
}

resource "aws_securityhub_organization_admin_account" "main" {
  admin_account_id = var.security_account_id
}

resource "aws_cloudtrail" "org_trail" {
  name                          = "${var.name_prefix}-org-trail"
  s3_bucket_name                = var.log_archive_bucket_name
  is_organization_trail         = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  include_global_service_events = true

  tags = var.tags
}

resource "aws_config_configuration_aggregator" "org" {
  name = "${var.name_prefix}-org-aggregator"

  organization_aggregation_source {
    all_regions = true
    role_arn    = var.config_aggregator_role_arn
  }

  tags = var.tags
}
