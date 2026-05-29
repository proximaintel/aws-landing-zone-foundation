# AWS WAF (Optional)

## Overview

This module deploys AWS WAF on Application Load Balancers or CloudFront distributions for web application protection.

**This is an add-on module** — not included in the core landing zone deployment. Deploy when public-facing applications are ready.

## When to Deploy

- Public-facing web applications are deployed
- ALB or CloudFront distribution exists
- Application-specific WAF rules are defined

## What's Included

- AWS WAF Web ACL
- Managed rule groups (AWS Core Rule Set, Known Bad Inputs, SQL Injection)
- Rate limiting rules
- IP reputation lists
- Custom rules (application-specific)
- CloudWatch metrics and logging to S3

## Prerequisites

- Core landing zone deployed
- ALB or CloudFront distribution provisioned
- Application team has defined protection requirements

## Pricing Consideration

WAF is priced per Web ACL + rules + requests. Typical engagement to deploy: $15-25K depending on application complexity and custom rule requirements.
