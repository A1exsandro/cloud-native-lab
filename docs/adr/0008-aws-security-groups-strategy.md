# ADR-0008: AWS Security Groups Strategy

- **Status:** Accepted
- **Date:** 2026-11-03
- **Decision Makers:** Cloud Native Lab
- **Related ADR:** ADR-0007 - AWS Network Architecture

## 1. Context

The Cloud Native Lab requires a consistent network security strategy for workloads deployed on Amazon Web Services (AWS).

The security architecture must provide:

- Controlled inbound and outbound traffic.
- Minimum necessary network permissions.
- Restricted administrative access.
- Protection against unnecessary public exposure.
- Terraform-based security configuration.
- Flexibility for future EC2, Docker and Kubernetes workloads.

## 2. Decision

We decided to use AWS Security Groups as the primary network firewall mechanism for EC2 instances and other supported AWS resources.

The security strategy follows the principle of least privilege.

### 2.1 Default Inbound Policy

Security Groups will follow a deny-by-default approach for inbound traffic.

No inbound rules will be configured unless explicitly required by a workload.

The initial Security Group:

- Name: `cloud-native-lab-ec2-sg`
- VPC: `cloud-native-lab-vpc`
- Region: `sa-east-1`

Initially, no inbound ports are exposed.

### 2.2 SSH Administrative Access

SSH access will only be enabled when administrative access to an EC2 instance is required.

The SSH policy is:

| Property | Configuration |
|---|---|
| Protocol | TCP |
| Port | 22 |
| Source | Administrative public IP |
| CIDR | `<ADMIN_PUBLIC_IP>/32` |

The administrative IP must be explicitly identified before configuring the rule.

Public SSH access from `0.0.0.0/0` is prohibited.

When possible, alternative access mechanisms such as AWS Systems Manager Session Manager should be evaluated.

### 2.3 HTTP and HTTPS Access

HTTP and HTTPS inbound rules will only be configured when applications need to be publicly accessible.

| Service | Protocol | Port |
|---|---|---|
| HTTP | TCP | 80 |
| HTTPS | TCP | 443 |

Rules must be associated with the appropriate workload and exposure requirements.

Public web services may accept traffic from `0.0.0.0/0` when public exposure is explicitly intended and protected by the application architecture.

Internal services must use restricted source ranges or references to other Security Groups.

### 2.4 Outbound Traffic

The initial EC2 Security Group permits outbound IPv4 traffic.

This is an initial laboratory decision intended to simplify package installation, updates and external service communication.

Outbound restrictions may be introduced as workloads and security requirements become more mature.

### 2.5 Security Groups vs Network ACLs

Security Groups and Network ACLs operate at different levels.

| Characteristic | Security Groups | Network ACLs |
|---|---|---|
| Association | Network interfaces/resources | Subnets |
| Stateful | Yes | No |
| Rules | Allow rules | Allow and deny rules |
| Rule evaluation | All applicable rules | Rules evaluated by number |
| Default behavior | No inbound access | Default NACL allows all traffic |

Security Groups will be the primary mechanism for workload-level access control.

Network ACLs may be introduced when subnet-level filtering or explicit network deny rules are required.

## 3. Alternatives Considered

### 3.1 Unrestricted Inbound Access

Rejected because exposing unnecessary ports increases the attack surface.

### 3.2 SSH from Any IPv4 Address

Rejected because unrestricted SSH exposes administrative services to the entire Internet.

### 3.3 Network ACLs as the Primary Firewall

Rejected for the initial implementation because Security Groups provide stateful, resource-level access control with simpler workload management.

## 4. Consequences

### Positive Consequences

- Reduced attack surface.
- Explicit administrative access control.
- No unnecessary inbound ports.
- Consistent security configuration through Terraform.
- Better separation between public and internal workloads.
- Easier auditing of network permissions.

### Negative Consequences

- Administrative IP changes require Security Group updates when SSH is used.
- Initial workloads may require additional rules before becoming accessible.
- Outbound access is still broadly permitted and may require future restriction.

## 5. Initial Implementation

The initial Security Group is managed by Terraform.

Resource:

`aws_security_group.ec2`

Configuration:

- VPC: `cloud-native-lab-vpc`
- Inbound: no rules initially.
- Outbound: IPv4 traffic allowed.
- Name: `cloud-native-lab-ec2-sg`.

Future SSH, HTTP and HTTPS rules will be introduced only when required.

## 6. References

- AWS Terraform environment:
  `infrastructure/terraform/environments/aws/`

- Security Group configuration:
  `infrastructure/terraform/environments/aws/security-groups.tf`

- Network architecture:
  `docs/adr/0007-aws-network-architecture.md`

- AWS Security Groups documentation:
  https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html

- AWS Network ACL documentation:
  https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html
  