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

---

## 2026-11-03 — Local Workstation Preparation and Storage Optimization

### Summary

Started preparing the local Ubuntu workstation to become the primary development and virtualization environment for the Cloud Native Lab.

The objective is to reduce infrastructure costs by prioritizing local resources before introducing additional remote infrastructure.

### Initial Environment Assessment

Workstation configuration:

- Operating System: Ubuntu 24.04
- CPU: AMD Ryzen 7 5800H
- CPU Resources: 8 cores / 16 threads
- Memory: Approximately 13.5 GiB
- Storage: NVMe SSD
- Virtualization: AMD-V / KVM support available
- Container Runtime: Docker Engine 29.3.0

### Storage Investigation

Initial disk assessment identified critical storage pressure:

- Root filesystem capacity: 247 GB.
- Initial disk usage: approximately 231 GB.
- Initial available space: approximately 4 GB.
- Initial utilization: approximately 99%.

The investigation identified significant storage consumption from:

- Docker build cache.
- Docker images and containers.
- Node.js and package manager caches.
- Android SDK and development tools.
- Gradle dependencies and build caches.
- Local development workspaces.

### Docker Storage Optimization

Docker storage usage was inspected using:

`docker system df -v`

The investigation identified approximately 36 GB of Docker build cache.

The build cache was removed using:

`docker builder prune -a`

This operation recovered approximately 34 GB of disk space.

Docker images, containers and persistent volumes were preserved.

### Development Cache Investigation

Additional cache directories were identified:

- Yarn cache.
- TypeScript cache.
- Python pip cache.
- Playwright browser cache.
- Gradle caches.

The npm cache cleanup was executed using:

`npm cache clean --force`

Other caches and development dependencies were inspected to identify further cleanup opportunities.

### Final Storage Assessment

After the cleanup activities:

| Metric | Initial | Current |
|---|---:|---:|
| Filesystem capacity | 247 GB | 247 GB |
| Used storage | 231 GB | 153 GB |
| Available storage | 4 GB | 83 GB |
| Utilization | 99% | 65% |

Approximately 78 GB of storage was recovered during the investigation and cleanup activities.

### Important Findings

- The workstation supports hardware virtualization through AMD-V.
- KVM kernel modules are available.
- Docker is already installed and operational.
- Ansible is not yet installed.
- `virsh` and `virt-manager` are not yet installed.
- Additional storage optimization opportunities remain in Android SDK and Gradle directories.

### Architectural Considerations

The local workstation will be prioritized as the initial development and virtualization environment.

This approach is aligned with ADR-0009 — Multi-Cloud Strategy and Infrastructure Evolution.

Local virtualization will be used to develop and validate infrastructure configurations before introducing additional remote resources.

### Next Steps

1. Review remaining storage optimization opportunities.
2. Install and configure KVM and Libvirt.
3. Install and configure Ansible.
4. Create the first Debian 13 virtual machine.
5. Establish a reproducible local infrastructure environment.
6. Document the virtualization architecture and automation procedures.

### Related ADRs

- ADR-0001 — Project Principles.
- ADR-0009 — Multi-Cloud Strategy and Infrastructure Evolution.
