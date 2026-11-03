# Engineering Journal

This journal records the evolution of the Cloud Native Lab project.

Unlike the Git history, this document captures the reasoning, milestones and lessons learned throughout the project.

---

# 2026

## July

### Project Started

The Cloud Native Lab repository was created.

Objectives:

- Build a production-like Cloud Native Platform
- Use Oracle Cloud Always Free
- Apply Platform Engineering practices
- Document every architectural decision

---

### Repository Foundation

Completed:

- Initial repository structure
- Development workflow
- Documentation
- Roadmap
- Architecture
- Development conventions

---

### Architecture Defined

Major architectural decisions:

- Oracle Cloud Infrastructure
- Debian 13
- Terraform
- Ansible
- RKE2
- ArgoCD
- Longhorn
- Traefik
- Vault

---

# Lessons Learned

This section records important lessons discovered during implementation.

Examples:

- OCI networking considerations
- Terraform module organization
- Kubernetes operational improvements

---

# Future Notes

This journal is intentionally informal.

It serves as an engineering notebook documenting the evolution of the platform beyond commit messages and Architecture Decision Records.
---

### 2026-11-03 — OCI Compute Bootstrap

Completed:

- Installed and configured OCI CLI on the local Ubuntu workstation.
- Confirmed OCI authentication and São Paulo (`sa-saopaulo-1`) as the tenancy home region.
- Selected an Ubuntu 24.04 ARM64 image compatible with `VM.Standard.A1.Flex`.
- Implemented the reusable Terraform Compute module.
- Integrated the Compute module into the Always Free environment.
- Configured the instance for 2 OCPUs, 12 GB RAM and a 50 GB boot volume.
- Configured SSH public key injection.
- Restricted public SSH ingress to the administrator CIDR (`/32`).
- Successfully executed `terraform fmt` and `terraform validate`.

Terraform validation:

- Configuration is valid.
- Initial plan: 1 resource to add and 1 resource to change.
- SSH security rule update was successfully applied.
- Compute instance creation remains pending.

Blocker:

OCI returned `Out of host capacity` when attempting to provision the Ampere A1 instance in the São Paulo region.

This is an OCI infrastructure capacity limitation, not a Terraform configuration validation error.

Current state:

- Networking resources remain provisioned.
- SSH ingress is restricted to the configured administrator CIDR.
- No Compute instance was successfully created.
- The Compute module remains implemented and ready for another provisioning attempt when capacity becomes available.

Next steps:

- Retry Compute provisioning when regional capacity permits.
- Consider testing a smaller A1 configuration if necessary.
- Review the administrator public IP periodically and update `admin_cidr` if it changes.

---

## 2026-11-03 — AWS Network Foundation

### Summary

Successfully provisioned the initial AWS networking infrastructure
for the Cloud Native Lab using Terraform.

### AWS Account and Authentication

- AWS account configured.
- IAM Identity Center enabled in `sa-east-1`.
- Administrative identity: `cloud-native-admin`.
- Permission set: `AdministratorAccess`.
- AWS CLI profile: `cloud-native-lab`.
- Authentication validated through temporary SSO credentials.
- Monthly AWS budget configured: USD 10.

### Network Implementation

Created the initial AWS VPC architecture in São Paulo (`sa-east-1`).

| Component | Configuration |
|---|---|
| VPC | 10.20.0.0/16 |
| Public Subnet | 10.20.10.0/24 |
| Private Subnet | 10.20.20.0/24 |
| Availability Zone | sa-east-1a |
| Internet Gateway | Created |
| Public Route Table | Created |
| Private Route Table | Created |
| NAT Gateway | Not provisioned |

### Terraform Result

Deployment completed successfully:

- 9 resources added.
- 0 resources changed.
- 0 resources destroyed.

AWS account and region outputs were validated.

### Architectural Decisions

- AWS infrastructure uses an independent Terraform environment and state.
- Public and private network segmentation was adopted.
- NAT Gateway was excluded to avoid recurring costs.
- Initial deployment uses a single Availability Zone.
- Terraform is the infrastructure management tool.

### Next Steps

1. Review and commit AWS network architecture documentation.
2. Implement Security Groups.
3. Evaluate EC2 instance types and current pricing.
4. Provision an initial compute instance.
5. Prepare the foundation for future Kubernetes workloads.

### Related ADR

- ADR-0007: AWS Network Architecture.
