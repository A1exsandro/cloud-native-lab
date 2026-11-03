# ADR-0007: AWS Network Architecture

- **Status:** Accepted
- **Date:** 2026-11-03
- **Decision Makers:** Cloud Native Lab
- **Related ADR:** ADR-0006 - Compute Architecture

## 1. Context

The Cloud Native Lab project requires a cloud networking foundation
to host infrastructure and applications on Amazon Web Services (AWS).

The architecture must provide:

- Network isolation.
- Public and private network segmentation.
- Controlled internet connectivity.
- Terraform-based infrastructure management.
- Cost-conscious resource selection.
- A foundation for future compute, Kubernetes and application workloads.

The AWS environment is independent from the existing Oracle Cloud
Infrastructure (OCI) environment.

AWS resources are provisioned in the São Paulo region (`sa-east-1`).

## 2. Decision

We decided to implement a dedicated AWS Virtual Private Cloud (VPC)
using Terraform.

### 2.1 VPC

| Property | Value |
|---|---|
| Name | cloud-native-lab-vpc |
| CIDR | 10.20.0.0/16 |
| Region | sa-east-1 |
| DNS Support | Enabled |
| DNS Hostnames | Enabled |

### 2.2 Network Segmentation

The VPC is divided into two subnets.

**Public Subnet**

| Property | Value |
|---|---|
| Name | cloud-native-lab-public-subnet |
| CIDR | 10.20.10.0/24 |
| Availability Zone | sa-east-1a |
| Automatic Public IPv4 | Enabled |

The public subnet is intended to host resources requiring
direct internet connectivity, subject to routing and security rules.

**Private Subnet**

| Property | Value |
|---|---|
| Name | cloud-native-lab-private-subnet |
| CIDR | 10.20.20.0/24 |
| Availability Zone | sa-east-1a |
| Automatic Public IPv4 | Disabled |

The private subnet is reserved for internal applications,
databases and services that should not be directly exposed
to the public internet.

### 2.3 Internet Connectivity

An Internet Gateway (IGW) is attached to the VPC.

A dedicated public route table contains:

| Destination | Target |
|---|---|
| 10.20.0.0/16 | Local |
| 0.0.0.0/0 | Internet Gateway |

The private route table contains only the local VPC route.

No NAT Gateway is provisioned.

This decision avoids recurring NAT Gateway hourly and
data-processing charges.

Consequently, resources in the private subnet do not have
direct outbound internet connectivity.

### 2.4 Availability Zones

The initial implementation uses a single Availability Zone:

`sa-east-1a`

This reduces initial architectural complexity and is sufficient
for the first laboratory workloads.

Multi-AZ architecture may be introduced in a future iteration.

### 2.5 Infrastructure as Code

All AWS networking resources are managed using Terraform.

The AWS environment maintains an independent Terraform state,
separate from the OCI environment.

AWS provider configuration:

- Provider: hashicorp/aws
- Region: sa-east-1
- Authentication: AWS IAM Identity Center
- CLI profile: cloud-native-lab

Default resource tags:

- Project: cloud-native-lab
- Environment: lab
- ManagedBy: terraform

## 3. Alternatives Considered

### 3.1 NAT Gateway

A NAT Gateway was considered for private subnet outbound connectivity.

It was rejected for the initial implementation because it introduces
recurring hourly and data-processing costs.

It can be introduced later when private workloads require outbound
internet access.

### 3.2 Multi-AZ Architecture

Deploying subnets across multiple Availability Zones was considered.

A single Availability Zone was selected for the initial laboratory
environment to reduce complexity.

High availability will be evaluated in a future architectural iteration.

### 3.3 Single Network Segment

Using only one subnet was considered but rejected.

Separating public and private workloads provides better network
organization, isolation and future scalability.

## 4. Consequences

### Positive Consequences

- Clear separation between public and private workloads.
- Dedicated network architecture for AWS.
- Infrastructure fully managed by Terraform.
- Reduced initial infrastructure costs.
- Foundation for future EC2, Kubernetes and application workloads.
- Independent AWS and OCI environments.

### Negative Consequences

- Private subnet resources do not have outbound internet access.
- Single Availability Zone does not provide multi-AZ resilience.
- Public workloads will require additional security controls.
- High availability and private outbound connectivity require
  future architectural improvements.

## 5. Initial Implementation

The initial deployment completed successfully.

Terraform result:

- Resources added: 9
- Resources changed: 0
- Resources destroyed: 0

Created resources:

1. AWS VPC
2. Public subnet
3. Private subnet
4. Internet Gateway
5. Public route table
6. Private route table
7. Public internet route
8. Public route table association
9. Private route table association

## 6. References

- AWS Terraform environment:
  `infrastructure/terraform/environments/aws/`

- Network configuration:
  `infrastructure/terraform/environments/aws/network.tf`

- Terraform provider:
  `infrastructure/terraform/environments/aws/provider.tf`

- Related decision:
  `docs/adr/0006-compute-architecture.md`
  