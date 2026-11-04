# ADR-0009 — Multi-Cloud Strategy and Infrastructure Evolution

**Status:** Accepted  
**Date:** 2026-11-03  
**Decision Makers:** Cloud Native Lab  
**Related ADRs:** ADR-0001, ADR-0002, ADR-0003, ADR-0006, ADR-0007, ADR-0008

---

## 1. Context

The Cloud Native Lab project initially adopted Oracle Cloud Infrastructure (OCI) as its primary cloud platform, prioritizing the Always Free resources to build a production-like Cloud Native environment while minimizing operational costs.

As the project evolved, the need to explore additional infrastructure environments emerged, including Amazon Web Services (AWS), local virtualization and potentially external virtual private servers (VPS).

The project requires an infrastructure strategy that supports progressive learning, practical experimentation, cost control and long-term architectural evolution.

The architecture must allow the development and validation of infrastructure components locally before introducing additional hosting and cloud resources.

The strategy must also preserve infrastructure independence between cloud providers, avoiding unnecessary coupling between OCI and AWS environments.

---

## 2. Decision

The Cloud Native Lab will adopt a progressive infrastructure evolution strategy based on three complementary stages:

1. Local Infrastructure
2. Remote Infrastructure
3. Multi-Cloud Infrastructure

OCI will remain the primary cloud platform for the initial Cloud Native platform implementation, leveraging Always Free resources whenever available.

AWS will serve as a complementary environment for cloud architecture experimentation, infrastructure automation and multi-cloud engineering practices.

### 2.1 Stage 1 — Local Infrastructure

The initial development and experimentation environment will run on the developer's local Linux workstation.

The local environment will provide the foundation for infrastructure development, automation and testing.

Initial technologies include:

- Ubuntu Linux
- KVM / Libvirt
- Debian 13 virtual machines
- Docker
- Terraform
- Ansible
- Git

Future local workloads may include:

- K3s or other lightweight Kubernetes distributions
- Argo CD
- Prometheus
- Grafana
- Container registries
- Supporting infrastructure services

Local infrastructure will be prioritized whenever it can satisfy development and experimentation requirements without requiring additional cloud expenses.

### 2.2 Stage 2 — Remote Infrastructure

When local infrastructure becomes insufficient or external accessibility is required, the project may introduce a remote virtual private server (VPS).

The VPS will provide an additional environment for remote infrastructure experimentation and externally accessible services.

Potential use cases include:

- WireGuard VPN deployment
- Secure remote access
- Remote Linux administration
- Network connectivity experiments
- Reverse proxy and ingress experimentation
- External service hosting
- Integration between local and cloud environments

The VPS provider has not been selected.

Providers such as Contabo may be evaluated alongside other alternatives based on:

- Monthly cost
- Available CPU and memory
- Storage capacity
- Network performance
- Geographic location
- Reliability
- Security capabilities

The VPS stage is optional and must be justified by technical requirements and available budget.

No permanent VPS subscription is required solely to advance the project.

### 2.3 Stage 3 — Multi-Cloud Infrastructure

The project will maintain independent infrastructure environments across Oracle Cloud Infrastructure and Amazon Web Services.

**Oracle Cloud Infrastructure (OCI)**

OCI will remain the primary platform for the initial production-like Cloud Native environment.

The implementation will prioritize:

- Always Free resources when eligible and available
- Terraform-based provisioning
- Compartment isolation
- Network segmentation
- Compute resources
- Kubernetes infrastructure
- Storage services
- GitOps and observability

**Amazon Web Services (AWS)**

AWS will be maintained as a complementary cloud environment for learning and experimentation.

The implementation will prioritize:

- IAM and Identity Center
- VPC and network architecture
- EC2
- Security Groups
- Infrastructure as Code
- Cost-aware resource provisioning
- Cloud-native service integration

Both cloud environments must maintain independent Terraform states, provider configurations and environment-specific resources.

Shared modules may be introduced when architectural compatibility and maintainability justify their use.

---

## 3. Infrastructure Evolution Strategy

The expected evolution is:

```text
                 CLOUD NATIVE LAB
                         |
                         |
                 LOCAL DEVELOPMENT
                         |
                Ubuntu / KVM / Libvirt
                         |
                   Debian 13 VMs
                         |
                  Docker / Ansible
                         |
                  Terraform / Git
                         |
                         v
                  REMOTE INFRASTRUCTURE
                         |
                  Optional VPS Provider
                         |
                 WireGuard / VPN
                         |
                  Secure Remote Access
                         |
                         v
                    MULTI-CLOUD
                         |
               +---------+---------+
               |                   |
               v                   v
             OCI                   AWS
               |                   |
          Kubernetes             EC2
          Terraform              VPC
          Ansible                IAM
          GitOps                 Security
               |                   |
               +---------+---------+
                         |
                         v
               CLOUD NATIVE PLATFORM
```

The stages represent an expected evolution rather than mandatory sequential dependencies.

Local, remote and cloud environments may coexist as the project matures.

---

## 4. Alternatives Considered

### 4.1 Cloud-First Development

Starting directly with cloud infrastructure was considered.

This approach was not selected as the default because it introduces recurring costs during early development and experimentation.

Local infrastructure provides a more economical environment for initial development and testing.

### 4.2 Single-Cloud Architecture

Maintaining only OCI was considered.

This option was not selected because AWS provides additional opportunities to study cloud architecture, identity management, networking and infrastructure automation.

### 4.3 VPS-First Infrastructure

Starting the project with a commercial VPS was considered.

This approach was not selected because the local workstation already provides sufficient resources for the initial virtualization and automation stages.

A VPS may be introduced later when remote access or external hosting becomes technically necessary.

### 4.4 Fully Local Infrastructure

Maintaining the entire laboratory locally was also considered.

This approach was not selected as the final architecture because it limits experimentation with cloud-native managed services, public cloud networking and distributed infrastructure.

---

## 5. Consequences

### Positive Consequences

- Progressive infrastructure investment.
- Lower initial operational costs.
- Greater control over development environments.
- Practical experience with local virtualization.
- Experience with remote infrastructure and VPN connectivity.
- Hands-on experience with OCI and AWS.
- Independent cloud environments.
- Better understanding of multi-cloud architectures.
- Improved infrastructure portability and automation.
- Stronger professional portfolio.

### Negative Consequences

- Multiple environments increase operational complexity.
- Local resources are limited by workstation capacity.
- Remote VPS infrastructure may introduce recurring costs.
- Multi-cloud environments require additional maintenance.
- Networking and connectivity between environments require careful security planning.
- Different cloud providers introduce service and configuration differences.

---

## 6. Cost Management Principles

The project will follow these cost management principles:

- Prefer local resources during initial development.
- Prioritize OCI Always Free resources when eligible and available.
- Use AWS resources on demand whenever possible.
- Avoid unnecessary always-on cloud resources.
- Introduce a VPS only when justified by technical requirements.
- Monitor cloud consumption and configure budget alerts.
- Avoid architectural decisions that create recurring costs without clear benefits.

---

## 7. Implementation Roadmap

The infrastructure evolution will follow these milestones:

| Stage | Milestone | Status |
|---|---|---|
| 1 | Prepare local Linux workstation | In Progress |
| 1 | Install and configure KVM / Libvirt | Planned |
| 1 | Deploy Debian 13 virtual machines | Planned |
| 1 | Configure Ansible automation | Planned |
| 1 | Deploy local Kubernetes environment | Planned |
| 2 | Evaluate VPS providers | Planned |
| 2 | Deploy optional remote VPS | Future |
| 2 | Configure WireGuard VPN | Future |
| 2 | Integrate remote and local environments | Future |
| 3 | Consolidate OCI infrastructure | In Progress |
| 3 | Expand AWS infrastructure | In Progress |
| 3 | Integrate GitOps and observability | Planned |

Milestone status must be updated as implementation progresses.

---

## 8. References

- ADR-0001 — Project Principles
- ADR-0002 — Terraform Authentication Strategy
- ADR-0003 — Network Architecture
- ADR-0006 — Compute Architecture
- ADR-0007 — AWS Network Architecture
- ADR-0008 — AWS Security Groups Strategy
- `infrastructure/terraform/`
- `infrastructure/ansible/`
- `docs/architecture.md`
- `docs/roadmap.md`
