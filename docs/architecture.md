# Architecture

This document describes the high-level architecture of the **Cloud Native Lab** project.

The objective is to build a production-like Kubernetes platform using Oracle Cloud Always Free while following Infrastructure as Code, GitOps and Platform Engineering best practices.

---

# Purpose

Cloud Native Lab is designed as a reproducible Cloud Native Platform where every infrastructure component is provisioned, configured and managed through code.

The platform emphasizes:

- Infrastructure as Code
- GitOps
- Automation
- Documentation
- Security
- Reproducibility

Rather than demonstrating isolated technologies, the project aims to present a complete platform lifecycle, from infrastructure provisioning to application deployment.

---

# Design Principles

The architecture is based on the following principles.

## Infrastructure as Code

Infrastructure must be provisioned exclusively through Terraform.

Manual changes to cloud resources should be avoided.

---

## Configuration as Code

Operating system configuration is managed using Ansible.

Servers should remain reproducible from a clean installation.

---

## GitOps

Kubernetes resources are managed declaratively.

ArgoCD continuously reconciles the cluster with the Git repository.

---

## Documentation First

Architectural decisions should be documented before implementation.

Documentation evolves together with the source code.

---

## Security by Default

Security is considered from the beginning of the project.

Examples include:

- Secret management
- Least privilege
- TLS
- Secure defaults
- Separation of responsibilities

---

## Production-like Architecture

Although built on Oracle Cloud Always Free, the project should resemble a real production platform whenever possible.

---

# Cloud Provider

The platform runs entirely on Oracle Cloud Infrastructure (OCI) Always Free.

Oracle Cloud was selected because it provides:

- ARM-based virtual machines
- Block Storage
- Virtual Cloud Network
- Public IPs
- Load balancing capabilities through MetalLB

while remaining free for continuous experimentation.

---

# Infrastructure

Infrastructure provisioning is performed with Terraform.

Terraform is responsible for:

- Networking
- Compute instances
- Storage
- Security configuration

Terraform represents the single source of truth for cloud resources.

---

# Network Topology

The infrastructure is organized using a Virtual Cloud Network (VCN).

```text
Internet
    │
Public IP
    │
Oracle Cloud VCN
    │
───────────────
Public Subnet
───────────────
    │
RKE2 Nodes
```

Networking decisions prioritize simplicity while remaining compatible with future expansion.

---

# Compute Layer

The cluster uses Oracle ARM virtual machines.

Initial topology:

- 1 Control Plane
- 2 Worker Nodes

This topology balances resource availability within the Oracle Always Free limits while providing enough capacity for platform services.

Future versions may introduce High Availability.

---

# Operating System

Debian 13 is used across all nodes.

Reasons for this choice include:

- Stability
- Large ecosystem
- Predictable upgrades
- Consistency with production environments maintained by the project

---

# Configuration Management

Ansible is responsible for configuring every server.

Responsibilities include:

- Package installation
- System configuration
- Kernel tuning
- Kubernetes prerequisites
- User configuration
- SSH hardening

No manual server configuration should become a permanent dependency.

---

# Kubernetes Platform

The platform uses RKE2.

RKE2 was selected because it provides:

- Production-ready defaults
- Security hardening
- CNCF-certified Kubernetes
- Compatibility with Rancher ecosystem

The Kubernetes cluster represents the foundation of the platform.

---

# GitOps

ArgoCD manages all Kubernetes workloads.

Git becomes the desired state of the platform.

Changes are applied through Pull Requests rather than direct cluster modifications.

---

# Networking

Traffic enters the platform through Traefik.

External services are exposed using MetalLB.

Responsibilities:

- HTTP routing
- HTTPS termination
- Ingress management
- LoadBalancer services

---

# Storage

Persistent storage is provided by Longhorn.

Longhorn offers:

- Persistent Volumes
- Snapshot support
- Volume replication
- Kubernetes-native storage management

Dedicated OCI Block Volumes are preferred over operating system disks.

---

# Security

Security services include:

- Vault
- External Secrets

Secrets should never be committed to the repository.

Authentication services such as Keycloak are deployed as applications on the platform.

---

# Observability

Platform monitoring consists of:

- Prometheus
- Grafana
- Loki

These components provide:

- Metrics
- Dashboards
- Log aggregation
- Operational visibility

---

# Applications

The platform hosts sample cloud-native applications.

Initial applications include:

- PostgreSQL
- Keycloak
- MinIO
- FastAPI
- React

Applications are intentionally separated from platform services.

---

# Repository Organization

The repository is organized according to platform responsibilities rather than technologies.

```text
Infrastructure
        │
Terraform
        │
Ansible
        │
Platform
        │
Applications
        │
Automation
        │
Documentation
```

This structure improves scalability and maintainability as the project grows.

---

# Architecture Decision Records

Significant architectural decisions are documented under:

```text
docs/adr/
```

Each ADR explains:

- Context
- Decision
- Consequences
- Alternatives considered

---

# Future Improvements

Potential future enhancements include:

- High Availability Control Plane
- Multi-region deployment
- Disaster Recovery
- Backup automation
- Policy enforcement
- Service Mesh
- External DNS
- Certificate automation
- Supply chain security
- Cost optimization

---

## Development Environment

Recommended tools:

- Ubuntu 24.04 LTS (Native or WSL)
- Git
- Terraform
- Ansible
- kubectl
- Helm
- OCI CLI
- Make
- jq
- yq

---

# Conclusion

Cloud Native Lab is intended to demonstrate the complete lifecycle of building and operating a production-like Cloud Native Platform.

Every architectural decision prioritizes automation, reproducibility, documentation and operational simplicity while remaining compatible with Oracle Cloud Always Free.