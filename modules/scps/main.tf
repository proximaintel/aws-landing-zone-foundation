resource "aws_organizations_policy" "deny_root" {
  name        = "deny-root-account"
  description = "Deny all actions by root user"
  content     = file("${path.module}/policies/deny-root-account.json")
  type        = "SERVICE_CONTROL_POLICY"
}

resource "aws_organizations_policy" "deny_leave_org" {
  name        = "deny-leave-org"
  description = "Prevent accounts from leaving the organization"
  content     = file("${path.module}/policies/deny-leave-org.json")
  type        = "SERVICE_CONTROL_POLICY"
}

resource "aws_organizations_policy" "require_imdsv2" {
  name        = "require-imdsv2"
  description = "Require IMDSv2 for all EC2 instances"
  content     = file("${path.module}/policies/require-imdsv2.json")
  type        = "SERVICE_CONTROL_POLICY"
}

resource "aws_organizations_policy" "deny_public_s3" {
  name        = "deny-public-s3"
  description = "Prevent disabling S3 public access block"
  content     = file("${path.module}/policies/deny-public-s3.json")
  type        = "SERVICE_CONTROL_POLICY"
}

resource "aws_organizations_policy_attachment" "deny_root" {
  policy_id = aws_organizations_policy.deny_root.id
  target_id = var.root_ou_id
}

resource "aws_organizations_policy_attachment" "deny_leave_org" {
  policy_id = aws_organizations_policy.deny_leave_org.id
  target_id = var.root_ou_id
}

resource "aws_organizations_policy_attachment" "require_imdsv2" {
  policy_id = aws_organizations_policy.require_imdsv2.id
  target_id = var.workloads_ou_id
}

resource "aws_organizations_policy_attachment" "deny_public_s3" {
  policy_id = aws_organizations_policy.deny_public_s3.id
  target_id = var.root_ou_id
}
