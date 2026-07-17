# Development Conventions

This document defines the development standards used throughout the Cloud Native Lab project.

The objective is to maintain consistency, readability and reproducibility as the project evolves.

---

# Repository Workflow

The repository follows a Git Flow-inspired workflow.

```text
main
    ▲
develop
    ▲
feature/*
```

Rules:

- No direct commits to `main`
- All development starts from `develop`
- Every feature is implemented in its own branch
- Changes are integrated through Pull Requests

---

# Commit Convention

The project follows Conventional Commits.

Examples:

```text
feat(terraform): add VCN module

feat(ansible): bootstrap Debian hosts

docs(readme): improve project overview

fix(rke2): correct server configuration

refactor(terraform): simplify network module

chore(github): add issue templates
```

---

# Branch Naming

Feature branches:

```text
feature/<short-description>
```

Examples:

```text
feature/project-structure
feature/terraform-bootstrap
feature/rke2-installation
feature/argocd
```

Bug fixes:

```text
fix/<description>
```

Documentation:

```text
docs/<description>
```

---

# Pull Requests

Every Pull Request should include:

- Summary
- Related Issue
- Changes
- Testing performed
- Documentation updates

Template:

```markdown
## Summary

...

## Related Issue

Closes #X

## Changes

- ...

## Checklist

- [ ] Documentation updated
- [ ] Tested locally
- [ ] Ready for review
```

---

# Documentation

Documentation is treated as code.

Every significant architectural decision should be documented before implementation.

Documentation updates are expected as part of every Pull Request.

---

# Infrastructure Standards

Infrastructure changes must be reproducible.

Terraform should remain the single source of truth for cloud resources.

Manual changes should be avoided.

---

# Kubernetes Standards

Kubernetes manifests should be declarative.

Configuration should be managed through GitOps.

Direct changes to running clusters should be avoided whenever possible.

---

# Security

The project adopts a security-first mindset.

Rules include:

- Never commit secrets
- Prefer least privilege
- Review permissions
- Keep dependencies updated

---

# Naming Conventions

Resources should use lowercase names.

Words are separated using hyphens.

Examples:

```text
terraform-network

rke2-control-plane

longhorn-storage

argocd-applications
```

---

# Documentation Language

Project documentation is written in English.

The objective is to maximize accessibility for the Cloud Native community.

---

# Code Quality

Every contribution should prioritize:

- Simplicity
- Readability
- Maintainability
- Reproducibility

Automation is preferred over manual procedures whenever practical.

---

# Continuous Improvement

These conventions may evolve as the project grows.

Any significant change should be documented through an Architecture Decision Record (ADR).