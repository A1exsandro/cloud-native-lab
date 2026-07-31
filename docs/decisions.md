# Architecture Decisions

This document provides a chronological overview of the major architectural decisions made throughout the Cloud Native Lab project.

Detailed discussions are documented as Architecture Decision Records (ADRs).

---

# Decision Log

| Date | Decision | Status | ADR |
|------|----------|--------|-----|
| 2026-07-16 | Define project principles | Accepted | ADR-0001 |
| 2026-07-16 | Use OCI CLI configuration for initial Terraform authentication | Accepted | ADR-0002 |
| 2026-07-16 | Adopt a modular single-VCN network architecture | Accepted | ADR-0003 |
| 2026-07-31 | Introduce a bootstrap Terraform layer for compartment creation | Accepted | ADR-0004 |
| 2026-07-31 | Keep NAT Gateway disabled by default in the Always Free environment | Accepted | ADR-0005 |

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
