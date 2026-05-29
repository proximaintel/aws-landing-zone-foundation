# Direct Connect (Optional)

## Overview

This module deploys AWS Direct Connect Gateway and Transit VIF for hybrid connectivity to on-premises data centers.

**This is an add-on module** — not included in the core landing zone deployment. Deploy when physical circuits are provisioned and carrier coordination is complete.

## When to Deploy

- Physical Direct Connect circuit is provisioned at a DX location
- On-premises router is configured for BGP peering
- Bandwidth and redundancy requirements are defined

## What's Included

- Direct Connect Gateway
- Transit Virtual Interface (Transit VIF) attached to Transit Gateway
- BGP peering configuration
- Route propagation to inspection VPC

## Prerequisites

- Core landing zone deployed (Transit Gateway must exist)
- Physical DX connection provisioned (connection ID required)
- BGP ASN for on-premises router

## Pricing Consideration

Direct Connect is priced per port-hour + data transfer. Typical engagement to deploy: $20-40K depending on redundancy requirements and carrier coordination.
