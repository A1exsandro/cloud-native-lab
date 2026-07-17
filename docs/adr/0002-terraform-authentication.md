# ADR-0002: Terraform Authentication Strategy

- **Status:** Accepted
- **Date:** 2026-07-16

## Context

Terraform requires authentication to provision and manage Oracle Cloud Infrastructure (OCI) resources.

Several authentication mechanisms are supported by OCI, including:

- OCI CLI configuration file (`~/.oci/config`)
- Environment variables
- Instance Principals
- Resource Principals

During the initial development phase of this project, the primary goal is to provide a simple and reproducible setup that can be executed by contributors in their local development environment.

## Decision

The project will initially use the OCI CLI configuration file located at:

```text
~/.oci/config
```

This authentication method is officially supported by Oracle and provides a straightforward developer experience without requiring additional infrastructure.

The Terraform provider will be configured to use the local OCI CLI profile during the early stages of the project.

As the platform evolves and infrastructure becomes operational within Oracle Cloud, the authentication strategy may transition to **Instance Principals** or another mechanism that better aligns with production security and automation requirements.

## Consequences

### Positive

- Simple local developer experience.
- Officially supported by Oracle Cloud.
- Easy onboarding for contributors.
- Compatible with the OCI CLI and Terraform.
- No additional infrastructure required during bootstrap.

### Negative

- Requires each developer to configure local OCI credentials.
- Not the preferred authentication mechanism for production automation.
- Credentials are stored locally and must be protected.

## Future Considerations

Future project milestones may replace this authentication strategy with:

- Instance Principals
- Resource Principals
- CI/CD authentication using secure credentials

Any future change to the authentication model must be documented in a new ADR.