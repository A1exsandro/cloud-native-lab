# Roadmap

This roadmap defines the planned evolution of the Cloud Native Lab project.

The project is organized into milestones, where each milestone delivers a functional improvement to the platform while maintaining a production-like approach.

---

# Project Status

| Milestone | Status |
|-----------|--------|
| Project Planning | ✅ Completed |
| Architecture Definition | ✅ Completed |
| Repository Structure | 🚧 In Progress |
| Infrastructure Provisioning | ⏳ Planned |
| Kubernetes Platform | ⏳ Planned |
| GitOps | ⏳ Planned |
| Platform Services | ⏳ Planned |
| Observability | ⏳ Planned |
| Sample Applications | ⏳ Planned |
| CI/CD | ⏳ Planned |

---

# Milestone 1 — Project Foundation

## Goal

Establish the project foundation, documentation and development workflow.

### Deliverables

- Project repository
- Git workflow
- Documentation
- ADR structure
- Project conventions

Status: 🚧 In Progress

---

# Milestone 2 — Infrastructure as Code

## Goal

Provision the Oracle Cloud infrastructure using Terraform.

### Deliverables

- Networking
- Virtual Cloud Network (VCN)
- Security Lists
- Compute Instances
- Block Volumes

Status: ⏳ Planned

---

# Milestone 3 — Server Configuration

## Goal

Configure all virtual machines using Ansible.

### Deliverables

- Debian hardening
- SSH configuration
- System updates
- Required packages
- Kubernetes prerequisites

Status: ⏳ Planned

---

# Milestone 4 — Kubernetes Platform

## Goal

Deploy a production-like RKE2 cluster.

### Deliverables

- RKE2
- Control Plane
- Worker Nodes
- kubeconfig
- Cluster validation

Status: ⏳ Planned

---

# Milestone 5 — Platform Services

## Goal

Deploy the core Cloud Native platform components.

### Deliverables

- Traefik
- MetalLB
- Longhorn
- ArgoCD
- Vault
- External Secrets

Status: ⏳ Planned

---

# Milestone 6 — Observability

## Goal

Provide monitoring and logging for the platform.

### Deliverables

- Prometheus
- Grafana
- Loki
- Dashboards
- Alerts

Status: ⏳ Planned

---

# Milestone 7 — Applications

## Goal

Deploy sample applications demonstrating the platform capabilities.

### Deliverables

- PostgreSQL
- Keycloak
- FastAPI
- React
- MinIO

Status: ⏳ Planned

---

# Milestone 8 — Automation

## Goal

Automate validation and deployment workflows.

### Deliverables

- GitHub Actions
- CI
- CD
- Validation workflows

Status: ⏳ Planned

---

# Future Improvements

The following items are intentionally outside the initial scope but may be implemented in future iterations.

- High Availability control plane
- Multi-node Longhorn optimization
- External DNS
- Cert Manager
- Harbor Registry
- Policy enforcement (Kyverno)
- Backup strategy
- Disaster Recovery
- Cost monitoring
- Multi-environment deployments

---

# Guiding Philosophy

The roadmap prioritizes learning, reproducibility and production-oriented practices over rapid implementation.

Every milestone should leave the platform in a stable and documented state before progressing to the next phase.