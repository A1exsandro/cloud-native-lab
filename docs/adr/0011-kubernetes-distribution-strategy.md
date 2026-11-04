# ADR-0011 — Kubernetes Distribution Strategy

**Status:** Accepted  
**Date:** 2026-11-04  
**Decision Makers:** Cloud Native Lab  
**Related ADRs:** ADR-0006, ADR-0009, ADR-0010

---

## 1. Context

Cloud Native Lab requires a Kubernetes platform that can be deployed consistently across local virtualization and cloud providers, including Contabo, Oracle Cloud Infrastructure (OCI), and Amazon Web Services (AWS).

The initial environment runs on a local Debian 13 virtual machine provisioned through KVM/Libvirt. The project aims to evolve this environment into a reproducible infrastructure platform using Terraform, Ansible, Kubernetes manifests, and GitOps.

The Kubernetes distribution must support:

- Local development and testing on limited hardware.
- Deployment on a single virtual machine for low-cost hosting.
- Automated installation and configuration.
- Reproducible infrastructure across different providers.
- Transferable Kubernetes knowledge applicable to professional environments.
- Future expansion to multi-node and highly available clusters.

The project must avoid unnecessary complexity during its initial implementation while preserving the ability to evolve its architecture.

## 2. Decision

K3s is selected as the primary Kubernetes distribution for the initial Cloud Native Lab implementation.

The initial cluster will use:

| Component | Decision |
|---|---|
| Kubernetes Distribution | K3s |
| Operating System | Debian 13 |
| Container Runtime | containerd |
| Initial Topology | Single-node cluster |
| Infrastructure Provisioning | Terraform |
| System Configuration | Ansible |
| Application Deployment | Kubernetes manifests and Kustomize |
| GitOps | ArgoCD, introduced in a later phase |
| Initial Environment | Local KVM/Libvirt virtual machine |
| Initial Cloud Target | Contabo single VM |

The implementation must keep infrastructure provisioning, operating system configuration, Kubernetes installation, cluster add-ons, and application deployment logically separated.

The project will preserve the possibility of implementing additional Kubernetes distributions, particularly kubeadm and RKE2, without coupling the application architecture to a specific distribution.

## 3. Kubernetes Distribution Strategy

### 3.1 Primary Distribution: K3s

K3s will be used for the initial implementation because it provides a lightweight Kubernetes distribution suitable for local development and single-node cloud deployments.

Its operational simplicity allows the project to focus on infrastructure automation, application deployment, networking, storage, security, and GitOps.

The initial deployment will use the standard K3s architecture, with containerd as its container runtime.

### 3.2 Alternative Distributions

The following distributions remain relevant to the project's learning and evolution strategy:

| Distribution | Intended Purpose | Priority |
|---|---|---|
| K3s | Initial local and low-cost cloud environments | Primary |
| kubeadm | Upstream Kubernetes installation and deeper component-level learning | Future |
| RKE2 | Enterprise-oriented Kubernetes environments and production operations | Future |
| Talos Linux | Exploration of immutable infrastructure and API-driven operating systems | Optional |

These alternatives will not be implemented as part of the initial cluster deployment.

### 3.3 Distribution Independence

Application manifests and infrastructure automation should avoid unnecessary dependencies on distribution-specific behavior.

Where distribution-specific configuration is required, it must be isolated in dedicated directories or Ansible roles.

The project should be able to reproduce its application platform using a different Kubernetes distribution with minimal changes to application deployment definitions.

## 4. Infrastructure and Automation Architecture

The Kubernetes installation process will be automated through Ansible.

Terraform will remain responsible for infrastructure provisioning, with separate implementations for each target environment.

The intended responsibilities are:

| Layer | Responsibility |
|---|---|
| Terraform | Virtual machine, networking, disks, and provider infrastructure |
| Ansible | Operating system preparation, security configuration, and Kubernetes installation |
| Kubernetes | Cluster resources and workloads |
| Kustomize | Application and environment manifests |
| ArgoCD | GitOps reconciliation and deployment automation |

The initial implementation will prioritize the existing local environment.

Future provider implementations must reuse the same configuration principles and application deployment architecture.

## 5. Alternatives Considered

### 5.1 kubeadm

kubeadm provides a standard way to bootstrap Kubernetes clusters using upstream Kubernetes components.

Advantages:
- Direct exposure to Kubernetes control-plane components.
- Strong alignment with upstream Kubernetes.
- Highly transferable knowledge across different environments.
- Flexible integration with infrastructure automation.

Disadvantages:
- Requires additional configuration and operational decisions.
- More initial complexity for a single-node, low-cost environment.

Decision: Deferred for a future implementation.

### 5.2 RKE2

RKE2 provides an enterprise-oriented Kubernetes distribution with a strong security focus.

Advantages:
- Production-oriented architecture.
- Security and compliance capabilities.
- Familiarity with the project's existing operational experience.
- Integration with the Rancher ecosystem.

Disadvantages:
- More components and operational considerations than necessary for the initial lightweight environment.

Decision: Retained as a future implementation option.

### 5.3 Talos Linux

Talos Linux provides an immutable operating system designed specifically for Kubernetes.

Advantages:
- API-driven system management.
- Immutable operating system approach.
- Reduced traditional operating system administration.

Disadvantages:
- Introduces a different operational model.
- Requires additional learning and adaptation of existing automation.

Decision: Deferred to an optional future experiment.

## 6. Consequences

### Positive Consequences

- Lightweight Kubernetes environment suitable for local virtualization.
- Lower resource requirements for the initial cloud deployment.
- Simplified installation and automation.
- Clear separation between infrastructure, cluster, and application responsibilities.
- Opportunity to develop transferable Kubernetes operational skills.
- Ability to reproduce the environment across different infrastructure providers.

### Negative Consequences

- K3s includes distribution-specific defaults and components that must be understood.
- Some configurations may require adaptation when moving to kubeadm or RKE2.
- A single-node cluster does not provide high availability.
- A single VM creates a shared failure domain for all workloads.
- Resource constraints may limit the number of applications and infrastructure services running simultaneously.

### Operational Considerations

The initial environment is intended for development, learning, portfolio demonstration, and low-cost hosting.

It must not be considered a highly available production architecture.

Data persistence, backup, recovery, network exposure, and security configuration must be addressed before exposing services publicly.

## 7. Implementation Roadmap

The implementation will follow these stages:

| Phase | Description | Target |
|---|---|---|
| 1 | Install K3s on the existing Debian 13 VM | Local |
| 2 | Validate cluster functionality and node health | Local |
| 3 | Configure networking and ingress | Local |
| 4 | Configure persistent storage | Local |
| 5 | Deploy PostgreSQL, Keycloak, and MinIO | Local |
| 6 | Deploy the Vocabulary API and web frontend | Local |
| 7 | Automate cluster installation and application deployment | Local |
| 8 | Reproduce the environment on a Contabo VM | Cloud |
| 9 | Evaluate OCI and AWS infrastructure implementations | Cloud |

The automation must allow the environment to be reconstructed with a small number of commands.

Cloud migration will be treated as infrastructure and workload reconstruction, including the necessary data backup and restoration procedures, rather than an in-place transfer of the existing cluster.

## 8. References

- Kubernetes Documentation — Production Environment.
- Kubernetes Documentation — kubeadm.
- K3s Documentation — Architecture and Installation.
- RKE2 Documentation — Architecture and Security.
- Talos Linux Documentation.
- ADR-0009 — Multi-Cloud Strategy and Infrastructure Evolution.
- ADR-0010 — Application Repository Strategy and Local Kubernetes Deployment.

---
