# Account Baseline — applied to every new account via AFT

resource "aws_vpc" "baseline" {
  cidr_block           = var.spoke_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, { Name = "${var.name_prefix}-spoke-vpc" })
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.baseline.id
  cidr_block        = cidrsubnet(var.spoke_vpc_cidr, 4, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.tags, { Name = "${var.name_prefix}-private-${count.index}" })
}

resource "aws_ec2_transit_gateway_vpc_attachment" "spoke" {
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = aws_vpc.baseline.id
  subnet_ids         = aws_subnet.private[*].id

  tags = merge(var.tags, { Name = "${var.name_prefix}-tgw-attach" })
}

resource "aws_budgets_budget" "monthly" {
  name         = "${var.name_prefix}-monthly-budget"
  budget_type  = "COST"
  limit_amount = tostring(var.budget_limit)
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 80
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}
