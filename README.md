# Cloud Native Lab

> A production-like Cloud Native Platform built on Oracle Cloud Always Free using Infrastructure as Code, GitOps and Kubernetes.

![Status](https://img.shields.io/badge/status-in%20development-orange)
![License](https://img.shields.io/badge/license-MIT-blue)
![Terraform](https://img.shields.io/badge/IaC-Terraform-623CE4)
![Ansible](https://img.shields.io/badge/Configuration-Ansible-EE0000)
![Kubernetes](https://img.shields.io/badge/Kubernetes-RKE2-326CE5)

---

## 📖 Overview

Cloud Native Lab is a personal Platform Engineering project focused on building a production-like Kubernetes platform entirely on the Oracle Cloud Always Free tier.

The project follows Infrastructure as Code, GitOps and Cloud Native best practices, emphasizing automation, documentation and reproducibility.

Rather than simply installing tools, the goal is to understand the architectural decisions behind each component and document the complete journey.

This repository documents the complete journey of designing, provisioning and operating a production-like Kubernetes platform from scratch.

Every architectural decision, implementation step and lesson learned is documented to create a reproducible learning platform and a long-term technical reference.

---

## 🎯 Objectives

- Build a production-like Kubernetes platform
- Use only Oracle Cloud Always Free resources
- Automate infrastructure provisioning with Terraform
- Configure hosts with Ansible
- Manage workloads through GitOps
- Document architectural decisions
- Create a fully reproducible environment
- Learn Platform Engineering practices
- Share knowledge with the community
- Serve as a long-term technical portfolio

---

## 🧭 Guiding Principles

This project is built around the following principles:

- Infrastructure as Code first
- GitOps by default
- Everything documented
- Security by default
- Automation over manual operations
- Production-like architecture
- Oracle Cloud Always Free compliant

These principles guide every architectural and implementation decision throughout the project lifecycle.

---

## 🏗️ Technology Stack

| Category | Technology |
|----------|------------|
| Cloud | Oracle Cloud Infrastructure |
| Operating System | Debian 13 |
| Infrastructure as Code | Terraform |
| Configuration Management | Ansible |
| Kubernetes | RKE2 |
| GitOps | ArgoCD |
| Ingress | Traefik |
| Load Balancer | MetalLB |
| Storage | Longhorn |
| Secrets | Vault + External Secrets |
| Monitoring | Prometheus + Grafana |
| Logging | Loki |
| Cloud Native Applications | FastAPI, React, PostgreSQL, Keycloak, MinIO |

---

## 🏛️ High-Level Architecture

```text
                        Oracle Cloud Infrastructure

                               Terraform
                                   │
                        ┌──────────┴──────────┐
                        │                     │
                   Networking           Compute
                        │                     │
                        └──────────┬──────────┘
                                   │
                             Debian 13 Servers
                                   │
                                 Ansible
                                   │
                                  RKE2
                                   │
        ┌──────────────────────────────────────────────────────────┐
        │                                                          │
    Traefik      MetalLB      Longhorn      ArgoCD      Vault
        │                                                          │
        └──────────────────────────────────────────────────────────┘
                                   │
                            Cloud Native Applications
```

---

## 🚀 Roadmap

- [x] Project planning
- [x] Define architecture
- [ ] Project structure
- [ ] Terraform bootstrap
- [ ] Oracle Cloud networking
- [ ] Compute instances
- [ ] Debian bootstrap
- [ ] RKE2 installation
- [ ] Longhorn
- [ ] Traefik
- [ ] MetalLB
- [ ] ArgoCD
- [ ] Vault
- [ ] Observability
- [ ] Applications
- [ ] CI/CD

For the complete roadmap, see [docs/roadmap.md](docs/roadmap.md).

---

## 📂 Repository Structure

```text
.
├── applications/
├── assets/
├── automation/
├── diagrams/
├── docs/
├── infrastructure/
├── platform/
├── scripts/
└── tests/
```

---

## 📚 Documentation

Project documentation is available in the `docs/` directory.

- Architecture
- Roadmap
- Conventions
- Journal
- Architecture Decision Records (ADR)

Each document is versioned alongside the source code to ensure the project remains fully reproducible and well documented.

---

## 🤝 Contributing

Although this is a personal project, contributions, suggestions and discussions are welcome.

Please read `CONTRIBUTING.md` before opening an Issue or Pull Request.

---

## 📜 License

This project is licensed under the MIT License.