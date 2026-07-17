# Architecture Decisions

This document provides a chronological overview of the major architectural decisions made throughout the Cloud Native Lab project.

Detailed discussions are documented as Architecture Decision Records (ADRs).

---

# Decision Log

| Date | Decision | Status | ADR |
|------|----------|--------|-----|
| 2026-07 | Use Oracle Cloud Always Free | Accepted | ADR-0001 |
| 2026-07 | Standardize on Debian 13 | Accepted | ADR-0002 |
| 2026-07 | Adopt Terraform for Infrastructure as Code | Accepted | ADR-0003 |
| 2026-07 | Adopt Ansible for Configuration Management | Accepted | ADR-0004 |
| 2026-07 | Use RKE2 as Kubernetes Distribution | Accepted | ADR-0005 |
| 2026-07 | Adopt ArgoCD for GitOps | Accepted | ADR-0006 |

---

# Decision Status

Possible decision states:

- Proposed
- Accepted
- Deprecated
- Superseded

---

# Decision Process

Significant architectural decisions follow this process:

1. Identify the problem
2. Evaluate alternatives
3. Document the rationale
4. Create an ADR
5. Implement
6. Review if necessary

---

# Philosophy

Architectural decisions should be explicit.

Recording decisions helps explain not only **what** was implemented, but also **why** it was implemented.