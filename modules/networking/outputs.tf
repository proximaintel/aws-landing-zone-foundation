output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.main.id
}

output "inspection_vpc_id" {
  value = aws_vpc.inspection.id
}

output "firewall_endpoint_ids" {
  value = aws_networkfirewall_firewall.main.firewall_status[0].sync_states[*].attachment[0].endpoint_id
}
