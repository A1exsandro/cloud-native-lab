# ADR-0001 — Project Principles

**Status:** Accepted

**Date:** 2026-07-16

---

## Context

The Cloud Native Lab project aims to build a production-like Kubernetes platform while maintaining consistency, reproducibility and long-term maintainability.

To ensure architectural coherence throughout the project, a common set of guiding principles is required.

---

## Decision

The project adopts the following principles:

- Infrastructure as Code first
- GitOps by default
- Documentation first
- Security by default
- Automation over manual operations
- Production-like architecture
- Oracle Cloud Always Free compatibility
- Continuous improvement

These principles guide every architectural and implementation decision made within the project.

---

## Alternatives Considered

No formal principles.

This option was rejected because it would likely lead to inconsistent architectural decisions over time.

---

## Consequences

Positive:

- Consistent decision-making
- Better documentation
- Easier onboarding
- Improved maintainability

Negative:

- Requires additional documentation effort before implementation.

---

## References

- docs/architecture.md
- docs/conventions.md
- docs/decisions.md