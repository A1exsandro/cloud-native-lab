# ADR-0006 — Compute Architecture

**Status:** Accepted

**Date:** 2026-11-03

---

## Context

The Cloud Native Lab requires a compute instance to host the initial Kubernetes platform and its supporting services.

The infrastructure is designed around Oracle Cloud Infrastructure Always Free resources, with cost control and infrastructure automation as primary considerations.

The initial deployment targets an ARM64-based Ampere instance in the São Paulo region.

## Decision

Use an OCI `VM.Standard.A1.Flex` instance with the following initial configuration:

- Architecture: ARM64
- Operating System: Ubuntu 24.04 LTS
- OCPUs: 2
- Memory: 12 GB
- Boot Volume: 50 GB
- Availability Domain: São Paulo AD-1
- Network: Public subnet
- Public IP: Enabled
- Network Security Group: Public NSG

The instance will be provisioned through a reusable Terraform Compute module.

SSH authentication will use an existing public key, with inbound SSH traffic restricted to the administrator's configured IPv4 CIDR.

The private key must remain outside the repository.

The initial deployment will use a public subnet to simplify bootstrap and administrative access. The existing networking architecture retains a private subnet for future workloads.

## Alternatives Considered

- **Debian 13 ARM64:** Initially preferred, but a compatible image was not found in the regional image query performed during implementation.
- **Ubuntu Minimal:** Not selected; the standard Ubuntu 24.04 ARM64 image was chosen.
- **Postpone Compute implementation:** Not selected because implementing and validating the reusable module can proceed independently of OCI capacity availability.

## Consequences

Positive:

- Uses an ARM64 instance compatible with the intended Always Free architecture.
- Keeps compute provisioning reusable and managed through Terraform.
- Establishes SSH access with public-key authentication.
- Restricts SSH ingress to the administrator CIDR.
- Provides a clear initial resource configuration for the Kubernetes lab.

Negative:

- OCI regional host capacity may prevent instance creation.
- The administrator CIDR may need updating if the public IP changes.
- A public subnet and public IP increase the importance of maintaining strict network security rules.
- The initial 2 OCPU and 12 GB configuration may need adjustment if capacity remains unavailable.

## References

- OCI Compute documentation: https://docs.oracle.com/en-us/iaas/Content/Compute/home.htm
- OCI Ampere A1 documentation: https://docs.oracle.com/en-us/iaas/Content/Compute/References/arm.htm
- Related ADRs: 0002, 0003, 0005
