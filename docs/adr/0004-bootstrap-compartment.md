# ADR-0004 — Bootstrap Terraform Layer For Compartments

**Status:** Accepted

**Date:** 2026-07-31

---

## Context

The main `always-free` Terraform environment requires a compartment OCID before it can provision networking, compute and platform resources.

Managing project resources directly in the Root Compartment would simplify the first apply, but it would reduce isolation, make cost and permission boundaries less clear and weaken the project as a professional portfolio.

The project therefore needs a reproducible way to create tenancy-scoped OCI resources before the environment-specific stack is executed.

---

## Decision

The project will use a dedicated Terraform bootstrap layer for tenancy-scoped resources.

The first bootstrap stack creates a compartment named `cloud-native-lab` through the reusable `modules/identity` module.

The `environments/always-free` stack will consume the resulting compartment OCID as an input and will not provision resources in the Root Compartment.

---

## Alternatives Considered

- Use the Root Compartment directly
- Create the compartment manually in the OCI Console
- Provision the compartment from the `always-free` environment

Using the Root Compartment was rejected because it weakens isolation and does not reflect good platform governance.

Creating the compartment manually was rejected because it breaks reproducibility.

Provisioning the compartment from the `always-free` environment was rejected because that environment already depends on the compartment OCID as input.

---

## Consequences

Positive:

- Clear separation between bootstrap and environment stacks
- Better isolation for project resources
- Reproducible compartment creation
- Stronger portfolio signal for platform governance

Negative:

- Introduces one additional Terraform stack
- Requires an explicit bootstrap step before the main environment

---

## References

- infrastructure/terraform/bootstrap/compartment
- infrastructure/terraform/modules/identity
- infrastructure/terraform/environments/always-free
