# AWS Landing Zone Foundation

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5-purple.svg)](https://www.terraform.io/)

**Production-ready Terraform modules for deploying an AWS Landing Zone — Control Tower, Organizations, SCPs, Transit Gateway, Network Firewall, and automated account vending for regulated industries.**

Built by [Proxima Intelligence](https://proximaintel.com) — Enterprise Cloud & AI Consulting.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    AWS Organizations                          │
│                                                             │
│  Root                                                       │
│  ├── Security OU                                            │
│  │   ├── Log Archive Account (CloudTrail, Config, Flow Logs)│
│  │   └── Security Tooling Account (GuardDuty, Security Hub) │
│  ├── Infrastructure OU                                      │
│  │   ├── Network Hub Account (TGW, Network Firewall, DNS)   │
│  │   └── Shared Services Account (CI/CD, artifacts)         │
│  ├── Workloads OU                                           │
│  │   ├── Production OU                                      │
│  │   └── Non-Production OU                                  │
│  ├── Sandbox OU                                             │
│  └── Suspended OU                                           │
└─────────────────────────────────────────────────────────────┘
```

### Network Topology

```
                        ┌─────────────────────┐
                        │    Internet          │
                        └──────────┬──────────┘
                                   │
                        ┌──────────┴──────────┐
                        │  Inspection VPC      │
                        │  (Network Firewall)  │
                        │  North-South +       │
                        │  East-West           │
                        └──────────┬──────────┘
                                   │
                        ┌──────────┴──────────┐
                        │  Transit Gateway     │
                        └──┬───────┬───────┬──┘
                           │       │       │
              ┌────────────┘       │       └────────────┐
              │                    │                    │
    ┌─────────┴─────┐   ┌────────┴────────┐   ┌──────┴──────┐
    │ Spoke VPC     │   │ Spoke VPC       │   │ On-Premises │
    │ (Workload A)  │   │ (Workload B)    │   │ (Optional   │
    │               │   │                 │   │  Direct     │
    └───────────────┘   └─────────────────┘   │  Connect)   │
                                              └─────────────┘
```

## Modules

| Module | Description | Included in $75K |
|--------|-------------|:---:|
| [organizations](modules/organizations/) | AWS Organizations with OU hierarchy | ✅ |
| [scps](modules/scps/) | 9 Service Control Policies | ✅ |
| [networking](modules/networking/) | Transit Gateway, Network Firewall, inspection VPC | ✅ |
| [security](modules/security/) | GuardDuty, Security Hub, Config, CloudTrail | ✅ |
| [identity](modules/identity/) | IAM Identity Center, permission sets | ✅ |
| [account-vending](modules/account-vending/) | Account Factory for Terraform (AFT) | ✅ |
| [optional/direct-connect](modules/optional/direct-connect/) | Direct Connect Gateway, Transit VIF | Add-on |
| [optional/waf](modules/optional/waf/) | AWS WAF on ALB/CloudFront | Add-on |

## Traffic Inspection Model

| Traffic Flow | Direction | Inspection | Service |
|---|---|---|---|
| Internet → Workload | North-South (inbound) | Network Firewall | Stateful rules |
| Workload → Internet | North-South (outbound) | Network Firewall | NAT → Firewall → IGW |
| Spoke → Spoke | East-West | Network Firewall | TGW → Inspection VPC → TGW |
| On-Prem → Cloud | Hybrid | Network Firewall | DX → TGW → Inspection VPC |

## Quick Start

```bash
git clone https://github.com/proximaintel/aws-landing-zone-foundation.git
cd aws-landing-zone-foundation/environments/production

cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

terraform init
terraform plan
terraform apply
```

## Prerequisites

- Terraform >= 1.5
- AWS CLI authenticated with management account credentials
- AWS Organizations enabled
- Control Tower deployed (recommended but not required)
- IAM Identity Center enabled

## Compliance Mapping

| Framework | Modules That Address It |
|-----------|------------------------|
| HIPAA | scps, security, networking, identity |
| FedRAMP Moderate | organizations, scps, networking, security, identity |
| PCI DSS v4.0 | networking, scps, security, identity |
| SOC 2 | security, identity, scps, organizations |
| CIS AWS v2.0 | All modules |

## Documentation

- [Architecture](docs/architecture.md) — detailed design decisions
- [Deployment Guide](docs/deployment-guide.md) — step-by-step instructions
- [Compliance Mapping](docs/compliance-mapping.md) — framework controls to modules
- [SCP Reference](docs/scp-reference.md) — all 9 policies explained
- [Day-2 Operations](docs/day2-operations.md) — ongoing management guide

## Optional Modules

### Direct Connect
For hybrid connectivity to on-premises data centers. Deploy when physical circuits are provisioned. See [modules/optional/direct-connect](modules/optional/direct-connect/).

### WAF
For web application protection on public-facing workloads. Deploy when applications are ready. See [modules/optional/waf](modules/optional/waf/).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## About Proxima Intelligence

[Proxima Intelligence](https://proximaintel.com) delivers the AWS Landing Zone Foundation as a [fixed-scope accelerator](https://proximaintel.com/accelerators/aws-landing-zone) — deployed in 4 weeks for regulated enterprises.

Senior architects on every engagement. No bait-and-switch.

---

*© Proxima Intelligence LLC. Licensed under Apache 2.0.*
