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
