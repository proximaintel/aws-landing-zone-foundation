resource "aws_ec2_transit_gateway" "main" {
  description                     = "Central Transit Gateway"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  auto_accept_shared_attachments  = "enable"

  tags = merge(var.tags, { Name = "${var.name_prefix}-tgw" })
}

resource "aws_ec2_transit_gateway_route_table" "inspection" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  tags               = merge(var.tags, { Name = "${var.name_prefix}-tgw-rt-inspection" })
}

resource "aws_ec2_transit_gateway_route_table" "spokes" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  tags               = merge(var.tags, { Name = "${var.name_prefix}-tgw-rt-spokes" })
}

# Inspection VPC
resource "aws_vpc" "inspection" {
  cidr_block           = var.inspection_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, { Name = "${var.name_prefix}-inspection-vpc" })
}

resource "aws_subnet" "firewall" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.inspection.id
  cidr_block        = cidrsubnet(var.inspection_vpc_cidr, 4, count.index)
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.tags, { Name = "${var.name_prefix}-firewall-${var.availability_zones[count.index]}" })
}

resource "aws_subnet" "tgw_attachment" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.inspection.id
  cidr_block        = cidrsubnet(var.inspection_vpc_cidr, 4, count.index + length(var.availability_zones))
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.tags, { Name = "${var.name_prefix}-tgw-${var.availability_zones[count.index]}" })
}

# Network Firewall
resource "aws_networkfirewall_firewall" "main" {
  name                = "${var.name_prefix}-network-firewall"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.main.arn
  vpc_id              = aws_vpc.inspection.id

  dynamic "subnet_mapping" {
    for_each = aws_subnet.firewall
    content {
      subnet_id = subnet_mapping.value.id
    }
  }

  tags = var.tags
}

resource "aws_networkfirewall_firewall_policy" "main" {
  name = "${var.name_prefix}-firewall-policy"

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]

    stateful_engine_options {
      rule_order = "STRICT_ORDER"
    }

    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.baseline.arn
      priority     = 100
    }
  }

  tags = var.tags
}

resource "aws_networkfirewall_rule_group" "baseline" {
  capacity = 1000
  name     = "${var.name_prefix}-baseline-rules"
  type     = "STATEFUL"

  rule_group {
    rule_variables {
      ip_sets {
        key = "HOME_NET"
        ip_set {
          definition = [var.inspection_vpc_cidr]
        }
      }
    }

    rules_source {
      rules_string = <<-EOT
        # Allow DNS
        pass tcp any any -> any 53 (msg:"Allow DNS TCP"; sid:1; rev:1;)
        pass udp any any -> any 53 (msg:"Allow DNS UDP"; sid:2; rev:1;)
        # Allow HTTPS outbound
        pass tcp any any -> any 443 (msg:"Allow HTTPS"; sid:3; rev:1;)
        # Drop all other traffic
        drop ip any any -> any any (msg:"Drop all other"; sid:999; rev:1;)
      EOT
    }

    stateful_rule_options {
      capacity = 1000
    }
  }

  tags = var.tags
}

# TGW Attachment for Inspection VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "inspection" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = aws_vpc.inspection.id
  subnet_ids         = aws_subnet.tgw_attachment[*].id

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = merge(var.tags, { Name = "${var.name_prefix}-tgw-attach-inspection" })
}
