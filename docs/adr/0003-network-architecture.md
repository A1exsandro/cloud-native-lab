# ADR-0003: Network Architecture

- **Status:** Accepted
- **Date:** 2026-07-16

## Context

The Cloud Native Lab will provision all infrastructure on Oracle Cloud Infrastructure (OCI) using Terraform.

A consistent network architecture is required to support current and future platform components, including:

- Kubernetes (RKE2)
- Longhorn
- Traefik
- PostgreSQL
- Keycloak
- Argo CD
- Monitoring Stack
- Future cloud-native applications

The networking design must be simple enough for the Always Free environment while remaining scalable to larger environments.

## Decision

The project adopts a modular networking architecture based on a single Virtual Cloud Network (VCN).

### Address Space

| Resource | CIDR |
|----------|------|
| VCN | 10.0.0.0/16 |

### Initial Subnets

| Subnet | CIDR | Purpose |
|---------|------|---------|
| Public | 10.0.10.0/24 | Load Balancers, Bastion (if required) |
| Private | 10.0.20.0/24 | Kubernetes Nodes and Platform Services |

### Connectivity

The VCN will contain:

- Internet Gateway
- NAT Gateway
- Route Tables
- Network Security Groups (NSGs)

Network Security Groups will be preferred over Security Lists whenever possible.

### Terraform Design

Networking resources will be implemented as an isolated Terraform module.

```
modules/networking/
```

The root module will only instantiate the networking module.

### Naming Convention

All networking resources will follow the project naming convention defined in `locals.tf`.

Example:

```
cloud-native-lab-always-free-vcn
cloud-native-lab-always-free-public-subnet
cloud-native-lab-always-free-private-subnet
```

### Tags

Every networking resource must receive the common Terraform tags defined by the project.

## Consequences

### Positive

- Consistent naming across all environments.
- Modular Terraform code.
- Easy future expansion.
- Reusable networking module.
- Supports production-grade infrastructure.

### Negative

- Slightly more initial planning.
- Additional Terraform modules to maintain.

## Future Considerations

Future environments may extend this architecture with:

- Multiple Availability Domains
- Additional private subnets
- Dedicated database subnet
- Kubernetes ingress subnet
- Service Gateway
- DRG (Dynamic Routing Gateway)
- Hub-and-Spoke networking