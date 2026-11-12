# Engineering Journal

This journal records the evolution of the Cloud Native Lab project.

Unlike the Git history, this document captures the reasoning, milestones and lessons learned throughout the project.

---

# 2026

## July

### Project Started

The Cloud Native Lab repository was created.

Objectives:

- Build a production-like Cloud Native Platform
- Use Oracle Cloud Always Free
- Apply Platform Engineering practices
- Document every architectural decision

---

### Repository Foundation

Completed:

- Initial repository structure
- Development workflow
- Documentation
- Roadmap
- Architecture
- Development conventions

---

### Architecture Defined

Major architectural decisions:

- Oracle Cloud Infrastructure
- Debian 13
- Terraform
- Ansible
- RKE2
- ArgoCD
- Longhorn
- Traefik
- Vault

---

# Lessons Learned

This section records important lessons discovered during implementation.

Examples:

- OCI networking considerations
- Terraform module organization
- Kubernetes operational improvements

---

# Future Notes

This journal is intentionally informal.

It serves as an engineering notebook documenting the evolution of the platform beyond commit messages and Architecture Decision Records.
---

### 2026-11-03 — OCI Compute Bootstrap

Completed:

- Installed and configured OCI CLI on the local Ubuntu workstation.
- Confirmed OCI authentication and São Paulo (`sa-saopaulo-1`) as the tenancy home region.
- Selected an Ubuntu 24.04 ARM64 image compatible with `VM.Standard.A1.Flex`.
- Implemented the reusable Terraform Compute module.
- Integrated the Compute module into the Always Free environment.
- Configured the instance for 2 OCPUs, 12 GB RAM and a 50 GB boot volume.
- Configured SSH public key injection.
- Restricted public SSH ingress to the administrator CIDR (`/32`).
- Successfully executed `terraform fmt` and `terraform validate`.

Terraform validation:

- Configuration is valid.
- Initial plan: 1 resource to add and 1 resource to change.
- SSH security rule update was successfully applied.
- Compute instance creation remains pending.

Blocker:

OCI returned `Out of host capacity` when attempting to provision the Ampere A1 instance in the São Paulo region.

This is an OCI infrastructure capacity limitation, not a Terraform configuration validation error.

Current state:

- Networking resources remain provisioned.
- SSH ingress is restricted to the configured administrator CIDR.
- No Compute instance was successfully created.
- The Compute module remains implemented and ready for another provisioning attempt when capacity becomes available.

Next steps:

- Retry Compute provisioning when regional capacity permits.
- Consider testing a smaller A1 configuration if necessary.
- Review the administrator public IP periodically and update `admin_cidr` if it changes.

---

## 2026-11-03 — AWS Network Foundation

### Summary

Successfully provisioned the initial AWS networking infrastructure
for the Cloud Native Lab using Terraform.

### AWS Account and Authentication

- AWS account configured.
- IAM Identity Center enabled in `sa-east-1`.
- Administrative identity: `cloud-native-admin`.
- Permission set: `AdministratorAccess`.
- AWS CLI profile: `cloud-native-lab`.
- Authentication validated through temporary SSO credentials.
- Monthly AWS budget configured: USD 10.

### Network Implementation

Created the initial AWS VPC architecture in São Paulo (`sa-east-1`).

| Component | Configuration |
|---|---|
| VPC | 10.20.0.0/16 |
| Public Subnet | 10.20.10.0/24 |
| Private Subnet | 10.20.20.0/24 |
| Availability Zone | sa-east-1a |
| Internet Gateway | Created |
| Public Route Table | Created |
| Private Route Table | Created |
| NAT Gateway | Not provisioned |

### Terraform Result

Deployment completed successfully:

- 9 resources added.
- 0 resources changed.
- 0 resources destroyed.

AWS account and region outputs were validated.

### Architectural Decisions

- AWS infrastructure uses an independent Terraform environment and state.
- Public and private network segmentation was adopted.
- NAT Gateway was excluded to avoid recurring costs.
- Initial deployment uses a single Availability Zone.
- Terraform is the infrastructure management tool.

### Next Steps

1. Review and commit AWS network architecture documentation.
2. Implement Security Groups.
3. Evaluate EC2 instance types and current pricing.
4. Provision an initial compute instance.
5. Prepare the foundation for future Kubernetes workloads.

### Related ADR

- ADR-0007: AWS Network Architecture.

---

## 2026-11-03 — Local Workstation Preparation and Storage Optimization

### Summary

Started preparing the local Ubuntu workstation to become the primary development and virtualization environment for the Cloud Native Lab.

The objective is to reduce infrastructure costs by prioritizing local resources before introducing additional remote infrastructure.

### Initial Environment Assessment

Workstation configuration:

- Operating System: Ubuntu 24.04
- CPU: AMD Ryzen 7 5800H
- CPU Resources: 8 cores / 16 threads
- Memory: Approximately 13.5 GiB
- Storage: NVMe SSD
- Virtualization: AMD-V / KVM support available
- Container Runtime: Docker Engine 29.3.0

### Storage Investigation

Initial disk assessment identified critical storage pressure:

- Root filesystem capacity: 247 GB.
- Initial disk usage: approximately 231 GB.
- Initial available space: approximately 4 GB.
- Initial utilization: approximately 99%.

The investigation identified significant storage consumption from:

- Docker build cache.
- Docker images and containers.
- Node.js and package manager caches.
- Android SDK and development tools.
- Gradle dependencies and build caches.
- Local development workspaces.

### Docker Storage Optimization

Docker storage usage was inspected using:

`docker system df -v`

The investigation identified approximately 36 GB of Docker build cache.

The build cache was removed using:

`docker builder prune -a`

This operation recovered approximately 34 GB of disk space.

Docker images, containers and persistent volumes were preserved.

### Development Cache Investigation

Additional cache directories were identified:

- Yarn cache.
- TypeScript cache.
- Python pip cache.
- Playwright browser cache.
- Gradle caches.

The npm cache cleanup was executed using:

`npm cache clean --force`

Other caches and development dependencies were inspected to identify further cleanup opportunities.

### Final Storage Assessment

After the cleanup activities:

| Metric | Initial | Current |
|---|---:|---:|
| Filesystem capacity | 247 GB | 247 GB |
| Used storage | 231 GB | 153 GB |
| Available storage | 4 GB | 83 GB |
| Utilization | 99% | 65% |

Approximately 78 GB of storage was recovered during the investigation and cleanup activities.

### Important Findings

- The workstation supports hardware virtualization through AMD-V.
- KVM kernel modules are available.
- Docker is already installed and operational.
- Ansible is not yet installed.
- `virsh` and `virt-manager` are not yet installed.
- Additional storage optimization opportunities remain in Android SDK and Gradle directories.

### Architectural Considerations

The local workstation will be prioritized as the initial development and virtualization environment.

This approach is aligned with ADR-0009 — Multi-Cloud Strategy and Infrastructure Evolution.

Local virtualization will be used to develop and validate infrastructure configurations before introducing additional remote resources.

### Next Steps

1. Review remaining storage optimization opportunities.
2. Install and configure KVM and Libvirt.
3. Install and configure Ansible.
4. Create the first Debian 13 virtual machine.
5. Establish a reproducible local infrastructure environment.
6. Document the virtualization architecture and automation procedures.

### Related ADRs

- ADR-0001 — Project Principles.
- ADR-0009 — Multi-Cloud Strategy and Infrastructure Evolution.

**## 2026-11-04 — Local Debian Virtualization and Ansible Bootstrap**

**### Summary**

Successfully established the first reproducible Debian 13 virtual machine in the local Cloud Native Lab environment.

The milestone covers local KVM/Libvirt virtualization, automated Debian installation, network configuration, SSH access, Ansible provisioning and Docker Engine installation.

**### Virtualization Environment**

Implemented the local virtualization environment using KVM and Libvirt.

Completed:

- Created the Debian 13 virtual machine `cnl-debian13-node01`.
- Configured 2 vCPUs and 3 GB RAM.
- Created a 30 GB QCOW2 virtual disk.
- Configured Libvirt NAT networking through `virbr0`.
- Configured DHCP reservation for the virtual machine.
- Automated Debian installation using Preseed.
- Configured the system timezone to `America/Cuiaba`.
- Enabled SSH and serial console access.

VM network configuration:

| Component | Configuration |
|---|---|
| VM | cnl-debian13-node01 |
| Operating System | Debian 13 |
| Kernel | 6.12.115 |
| vCPUs | 2 |
| Memory | 3 GB |
| Virtual Disk | 30 GB |
| Network | Libvirt default (NAT) |
| IP Address | 192.168.122.176 |
| Gateway | 192.168.122.1 |
| SSH | Port 22 |

A DHCP reservation was configured using the VM's MAC address to maintain a consistent IP address.

**### Network and Connectivity**

Completed:

- Configured Libvirt NAT networking.
- Enabled IP forwarding.
- Added the required UFW forwarding rule between `virbr0` and `wlo1`.
- Confirmed DHCP address assignment.
- Successfully established SSH connectivity from the Ubuntu host.

**### Ansible Bootstrap**

Implemented and executed the initial Ansible provisioning workflow.

The bootstrap playbook includes:

- Common system configuration.
- Hostname and timezone configuration.
- APT package updates and upgrades.
- Essential infrastructure packages.
- QEMU Guest Agent.
- OpenSSH server configuration.
- SSH public key deployment.
- Additional infrastructure tools.

The first execution completed successfully.

Ansible execution result:

| Metric | Result |
|---|---:|
| Successful tasks | 14 |
| Changed tasks | 4 |
| Failed tasks | 0 |
| Unreachable hosts | 0 |

**### Idempotency Validation**

Executed the bootstrap playbook a second time to validate idempotency.

Result:

- 13 tasks completed successfully.
- 0 changes.
- 0 failures.
- 0 unreachable hosts.

This confirms that the bootstrap playbook maintains the desired system state without unnecessary modifications on subsequent executions.

**### Docker Engine Installation**

Implemented and executed the independent Docker Ansible role.

Installed components:

- Docker Engine Community.
- Docker CLI.
- Containerd.
- Docker Buildx.
- Docker Compose Plugin.

The Docker service was successfully installed and enabled.

The administrative user `cnladmin` was configured as a member of the `docker` group.

Initial validation confirmed Docker Engine and Docker Compose client availability.

A permission error occurred when attempting to access `/var/run/docker.sock` immediately after installation. This is expected when the current login session has not yet refreshed its group membership.

Docker container execution remains pending validation after reconnecting the SSH session.

**### Engineering Decisions**

- Kept Docker installation separate from the general Debian bootstrap.
- Maintained independent Ansible roles for system preparation and container runtime installation.
- Used the official Docker APT repository.
- Adopted DHCP reservation for predictable local VM addressing.
- Retained SSH key-based administration.
- Used local virtualization as the initial infrastructure validation environment.

**### Lessons Learned**

- Libvirt NAT forwarding must be compatible with the host firewall configuration.
- Debian installation and post-installation serial console configuration require separate consideration.
- Ansible privilege escalation requires an explicit become password when credentials are not stored.
- Linux group membership changes require a new login session to take effect.
- Idempotency validation is essential before expanding infrastructure automation.

**### Current State**

- Local KVM/Libvirt environment operational.
- Debian 13 virtual machine provisioned.
- SSH connectivity validated.
- DHCP reservation configured.
- Ansible bootstrap completed.
- Bootstrap idempotency confirmed.
- Docker Engine and Compose Plugin installed.
- Docker socket permissions awaiting final validation.

**### Next Steps**

1. Validate Docker access after reconnecting the SSH session.
2. Execute the `hello-world` container.
3. Validate Docker role idempotency.
4. Review and commit the Docker provisioning implementation.
5. Expand the local infrastructure automation.
6. Prepare the environment for future RKE2 cluster deployment.

---

# 2026-11-04 — Local Infrastructure, Ansible Automation and K3s Deployment

### Summary

Successfully established the first reproducible Kubernetes environment in the local Cloud Native Lab infrastructure.

The milestone covers local KVM/Libvirt virtualization, automated Debian 13 installation, network configuration, Ansible provisioning, Docker Engine installation, K3s deployment, administrative access configuration and Kubernetes cluster validation.

The first single-node Kubernetes cluster is now operational and managed through Ansible.

### Virtualization Environment

Implemented the local virtualization environment using KVM and Libvirt.

Completed:

- Created the Debian 13 virtual machine `cnl-debian13-node01`.
- Configured 2 vCPUs and 3 GB RAM.
- Created a 30 GB QCOW2 virtual disk.
- Configured Libvirt NAT networking through `virbr0`.
- Configured DHCP reservation for the virtual machine.
- Automated Debian installation using Preseed.
- Configured the system timezone to `America/Cuiaba`.
- Enabled SSH and serial console access.
- Established stable network addressing through DHCP reservation.

VM network configuration:

| Component | Configuration |
|---|---|
| VM | cnl-debian13-node01 |
| Operating System | Debian 13 |
| Kernel | 6.12.115 |
| vCPUs | 2 |
| Memory | 3 GB |
| Virtual Disk | 30 GB |
| Network | Libvirt default (NAT) |
| IP Address | 192.168.122.176 |
| Gateway | 192.168.122.1 |
| SSH | Port 22 |

A DHCP reservation was configured using the VM MAC address `52:54:00:5a:c4:82` to maintain a consistent IP address.

### Network and Connectivity

Completed:

- Configured Libvirt NAT networking.
- Enabled IP forwarding.
- Added the required UFW forwarding rule between `virbr0` and `wlo1`.
- Confirmed DHCP address assignment.
- Successfully established SSH connectivity from the Ubuntu host.
- Corrected the DHCP reservation after identifying a MAC address mismatch.

The VM is accessible through SSH using its reserved address.

### Ansible Bootstrap

Implemented and executed the initial Ansible provisioning workflow.

The bootstrap playbook includes:

- Common system configuration.
- Hostname and timezone configuration.
- APT package updates and upgrades.
- Essential infrastructure packages.
- QEMU Guest Agent.
- OpenSSH server configuration.
- SSH public key deployment.
- Additional infrastructure tools.

The first execution completed successfully.

Ansible execution result:

| Metric | Result |
|---|---:|
| Successful tasks | 14 |
| Changed tasks | 4 |
| Failed tasks | 0 |
| Unreachable hosts | 0 |

### Idempotency Validation

Executed the bootstrap playbook a second time to validate idempotency.

Result:

- 13 tasks completed successfully.
- 0 changes.
- 0 failures.
- 0 unreachable hosts.

This confirms that the bootstrap playbook maintains the desired system state without unnecessary modifications on subsequent executions.

### Docker Engine Installation

Implemented and executed the independent Docker Ansible role.

Installed components:

- Docker Engine Community.
- Docker CLI.
- Containerd.
- Docker Buildx.
- Docker Compose Plugin.

The Docker service was successfully installed and enabled.

The administrative user `cnladmin` was configured as a member of the `docker` group.

Validation completed successfully:

- Docker Engine version verified.
- Docker Compose version verified.
- Docker socket access validated after reconnecting the SSH session.
- Docker container execution validated using the official `hello-world` image.

Docker installation and container execution were successfully validated.

Docker remains independent from the Kubernetes installation because K3s provides its own containerd runtime.

### Current State

- Docker Engine installed and operational.
- Docker Compose Plugin installed and operational.
- Docker socket permissions validated.
- Docker container execution confirmed.
- Docker provisioning role implemented.

Docker validation is complete.

### Kubernetes Distribution Strategy

Created and accepted ADR-0011 — Kubernetes Distribution Strategy.

The decision establishes K3s as the primary Kubernetes distribution for the initial Cloud Native Lab implementation.

The strategy considers:

- K3s as the primary lightweight distribution.
- kubeadm as a future upstream Kubernetes implementation.
- RKE2 as an enterprise-oriented alternative.
- Talos Linux as an optional future experiment.

The architecture prioritizes reproducible deployments across local virtualization and cloud providers.

### K3s Ansible Implementation

Implemented a dedicated Ansible role for K3s installation.

Created:

- `roles/k3s/defaults/main.yml`
- `roles/k3s/tasks/main.yml`
- `roles/k3s/handlers/main.yml`
- `roles/k3s/templates/config.yaml.j2`
- `playbooks/kubernetes.yml`

The Kubernetes installation is independent from the general Debian bootstrap and Docker provisioning workflows.

K3s configuration:

| Component | Configuration |
|---|---|
| Distribution | K3s |
| Version | v1.36.5+k3s1 |
| Operating System | Debian 13 |
| Runtime | containerd |
| Topology | Single-node |
| Datastore | SQLite |
| CNI | Flannel |
| Ingress Controller | Traefik |
| Storage Provisioner | Local Path Provisioner |
| Installation | Ansible |

The K3s installation uses the official installer with a version explicitly pinned through Ansible variables.

### Kubernetes Cluster Deployment

Successfully installed K3s on `cnl-debian13-node01` using the dedicated Ansible playbook.

The installation completed without failures.

Initial execution result:

| Metric | Result |
|---|---:|
| Successful tasks | 8 |
| Changed tasks | 5 |
| Failed tasks | 0 |
| Unreachable hosts | 0 |

The K3s systemd service was successfully enabled and started.

Cluster validation confirmed:

| Component | Status |
|---|---|
| K3s Service | Active |
| Control Plane | Ready |
| CoreDNS | Running |
| Traefik | Running |
| Metrics Server | Running |
| Local Path Provisioner | Running |
| Service LoadBalancer | Running |

Node configuration:

| Component | Value |
|---|---|
| Node | cnl-debian13-node01 |
| Internal IP | 192.168.122.176 |
| Kubernetes Version | v1.36.5+k3s1 |
| Container Runtime | containerd://2.3.4-k3s1.36 |
| Node Status | Ready |

### Kubernetes Administrative Access

Configured administrative kubeconfig access through Ansible.

The implementation provides two administration paths:

**Local workstation:**

- Kubeconfig: `~/.kube/cloud-native-lab.yaml`
- API Server: `https://192.168.122.176:6443`
- File permissions: `0600`

**Debian virtual machine:**

- Kubeconfig: `/home/cnladmin/.kube/config`
- File permissions: `0600`
- Environment variable: `KUBECONFIG`
- K3s client configuration override: `K3S_CONFIG_FILE=/dev/null`

The environment configuration avoids permission warnings caused by the K3s client attempting to read root-protected configuration files.

Administrative access was successfully validated from both the Ubuntu workstation and the Debian VM.

Validated commands:

- `kubectl get nodes`
- `kubectl get pods -A`

Both access paths successfully communicate with the same Kubernetes cluster without requiring sudo.

Kubeconfig files contain administrative credentials and must remain outside the Git repository.

### Ansible Quality and Validation

Validated the Kubernetes playbook using Ansible syntax checking and Ansible Lint.

Results:

- Syntax validation passed.
- Ansible Lint passed.
- Production profile requirements satisfied.
- No lint failures.
- No lint warnings.

The K3s playbook was executed again to validate idempotency.

The second execution completed successfully without failures.

### Engineering Decisions

- Kept Docker installation separate from the general Debian bootstrap.
- Kept K3s installation independent from Docker provisioning.
- Selected K3s as the initial Kubernetes distribution.
- Pinned the Kubernetes distribution version through Ansible variables.
- Used containerd as the Kubernetes container runtime.
- Retained Flannel as the initial CNI.
- Retained Traefik as the initial ingress controller.
- Used SQLite as the initial K3s datastore.
- Preserved administrative kubeconfig permissions.
- Configured administrative access from both the workstation and the VM.
- Kept Kubernetes installation and configuration reproducible through Ansible.
- Maintained local virtualization as the initial infrastructure validation environment.

### Lessons Learned

- DHCP reservations must match the actual VM MAC address.
- Libvirt NAT forwarding must be compatible with the host firewall configuration.
- Ansible privilege escalation requires an explicit become password when credentials are not stored.
- SSH authentication and Ansible privilege escalation are separate concerns.
- K3s provides its own containerd runtime and does not require Docker Engine.
- K3s administrative kubeconfig permissions must be handled carefully.
- K3s client configuration can produce permission warnings when a non-root user accesses root-protected configuration files.
- Kubernetes administration can be performed remotely through a protected kubeconfig.
- Ansible syntax validation and linting should be performed before provisioning.
- Idempotency validation is essential before expanding infrastructure automation.
- A single-node Kubernetes cluster is suitable for initial development but does not provide high availability.
- The initial VM memory allocation will need to be reviewed before deploying multiple infrastructure services.

### Current State

- Local KVM/Libvirt environment operational.
- Debian 13 virtual machine provisioned.
- Stable DHCP reservation configured.
- SSH connectivity validated.
- Ansible bootstrap completed.
- Bootstrap idempotency confirmed.
- Docker Engine and Compose Plugin installed.
- K3s installed through Ansible.
- Kubernetes control plane operational.
- Node status Ready.
- CoreDNS operational.
- Traefik operational.
- Metrics Server operational.
- Local Path Provisioner operational.
- Administrative kubeconfig configured on the workstation.
- Administrative kubeconfig configured inside the VM.
- Kubernetes playbook syntax validation passed.
- Ansible Lint production profile passed.
- K3s idempotency validation completed successfully.

### Next Steps

1. Review and commit the K3s Ansible implementation.
2. Update and consolidate the project documentation.
3. Validate Docker container execution and Docker role idempotency.
4. Review the local Kubernetes networking architecture.
5. Evaluate persistent storage requirements and limitations of the single-node environment.
6. Define the initial Kubernetes namespace and application deployment structure.
7. Prepare PostgreSQL, Keycloak and MinIO deployment configurations.
8. Deploy the Vocabulary API and web frontend.
9. Evaluate resource allocation before deploying the complete application stack.
10. Prepare the automation architecture for future Contabo, OCI and AWS implementations.

---

## 2026-11-04 — Local PostgreSQL Deployment on K3s

### Objective

Deploy the first database service in the local Cloud Native Lab Kubernetes environment.

The goal was to establish a reusable PostgreSQL foundation for future platform applications, starting with Keycloak and Vocabulary.

### Environment

- Operating System: Debian 13
- Kubernetes Distribution: K3s
- Kubernetes Version: v1.36.5+k3s1
- Node: `cnl-debian13-node01`
- Namespace: `database`
- PostgreSQL Image: `postgres:18.6-bookworm`

### Implementation

The PostgreSQL deployment was organized using Kustomize, separating reusable base manifests from environment-specific configuration.

The resulting structure:

```text
platform/kubernetes/
├── base/
│   └── postgresql/
│       ├── kustomization.yaml
│       ├── namespace.yaml
│       ├── pvc.yaml
│       ├── service.yaml
│       └── statefulset.yaml
├── overlays/
│   └── local/
│       └── postgresql/
│           ├── kustomization.yaml
│           └── secrets/
│               └── postgres-password
└── secrets/
    └── local/
```

The deployment includes:

- PostgreSQL StatefulSet with one replica.
- PersistentVolumeClaim requesting 10 GiB.
- `local-path` StorageClass.
- Headless Kubernetes Service on port 5432.
- Dedicated `database` namespace.
- Kubernetes Secret generated through Kustomize `secretGenerator`.

### Secret Management

A local password file was generated and stored outside Git tracking.

The `.gitignore` configuration was updated to prevent local credentials from being committed.

Kustomize initially rejected references to files outside the overlay directory due to its security restrictions.

The configuration was reorganized so that the password file resides inside the local overlay directory. This allowed Kustomize to generate the Secret without disabling its security protections.

### Deployment and Validation

The following resources were successfully created:

- Namespace: `database`
- Secret: `postgresql-credentials`
- Service: `postgresql`
- PersistentVolumeClaim: `postgresql-data`
- StatefulSet: `postgresql`

Validation results:

| Component | Result |
|---|---|
| PostgreSQL Pod | Running |
| StatefulSet | 1/1 Ready |
| PersistentVolumeClaim | Bound |
| Persistent Storage | 10 GiB |
| StorageClass | local-path |
| Service | Headless, port 5432 |
| Container Restarts | 0 |

PostgreSQL initialization completed successfully.

The database logs confirmed that PostgreSQL 18.6 was ready to accept connections.

A connection test was also performed inside the container:

```sql
SELECT version(), current_user, current_database();
```

The test successfully returned:

- PostgreSQL version: 18.6
- Current user: `postgres_admin`
- Current database: `postgres_admin`

This validated local database access. Password authentication over the Kubernetes network remains a separate validation task.

### Lessons Learned

- Kustomize restricts references to files outside the current build directory.
- `secretGenerator` provides a convenient way to generate Kubernetes Secrets from local files.
- Sensitive credentials must remain outside Git tracking.
- StatefulSets and persistent volumes provide a suitable foundation for stateful workloads.
- A successful Kubernetes deployment must be followed by application-level connectivity tests.

### Future Notes

The following tasks remain planned:

1. Configure and verify password authentication for network connections.
2. Review PostgreSQL authentication settings, including the local `trust` authentication warning observed during initialization.
3. Create dedicated databases and users for Keycloak and Vocabulary.
4. Implement a PostgreSQL backup strategy.
5. Monitor memory consumption as additional platform services are deployed.

### Milestone

The first stateful database service was successfully deployed in the local Cloud Native Lab Kubernetes environment.

This establishes the database foundation for the next platform components.

## 2026-11-05 — AWS Ohio PostgreSQL, Keycloak and HTTPS Deployment

### Objective

Deploy the core identity and database services in the Cloud Native Lab AWS environment.

The goal was to establish a production-oriented foundation for future applications, including Vocabulary, using K3s, PostgreSQL, Keycloak, Traefik, and cert-manager.

### Environment

- Cloud Provider: AWS
- Region: `us-east-2` (Ohio)
- Operating System: Debian 13
- Instance Type: `m7i-flex.large`
- Instance Resources: 2 vCPU, 8 GiB RAM
- Root Volume: 40 GiB gp3
- Kubernetes Distribution: K3s
- Kubernetes Version: v1.36.5+k3s1
- Container Runtime: containerd 2.3.4-k3s1
- Node: `cnl-aws-ohio-node01`
- Node Private IP: `10.20.10.125`
- PostgreSQL Image: `postgres:18.6-bookworm`
- Keycloak Image: `quay.io/keycloak/keycloak:26.8.1`

### Infrastructure and Access

The AWS environment was provisioned using Terraform.

The infrastructure includes:

- VPC with CIDR `10.20.0.0/16`.
- Public subnet for the K3s node.
- Internet Gateway and public routing.
- EC2 Security Group with restricted SSH and Kubernetes API access.
- Public HTTP and HTTPS access for application traffic.
- K3s configured as a single-node cluster.

A dedicated kubeconfig was configured on the workstation, using the `kubectl-aws` alias to avoid accidentally targeting the work production cluster.

### PostgreSQL Deployment

PostgreSQL was deployed in the `database` namespace using Kustomize.

The AWS overlay reuses the PostgreSQL base manifests and provides environment-specific credentials.

The deployment includes:

- StatefulSet with one replica.
- PersistentVolumeClaim requesting 10 GiB.
- `local-path` StorageClass.
- Headless Service on port 5432.
- Kubernetes Secret generated through Kustomize.
- Initialization script mounted through a ConfigMap.

A database and dedicated user for Keycloak were created during PostgreSQL initialization:

- Database: `keycloak`
- User: `keycloak_user`
- Administrative database user: `postgres_admin`

Validation confirmed that the database and role were created successfully and that `keycloak_user` could connect to the `keycloak` database.

The PostgreSQL pod reached `1/1 Ready`, and the PVC reached `Bound`.

### Secret Management

Environment-specific credentials are stored in local files under the AWS overlays and excluded from Git tracking.

Kustomize `secretGenerator` is used to create Kubernetes Secrets.

During deployment, a password authentication mismatch was identified between PostgreSQL and Keycloak.

The investigation revealed that password files generated with `openssl rand -hex 32` contained an additional newline character.

The administrative password file was regenerated using:

```bash
openssl rand -hex 32 | tr -d '\n' > keycloak-admin-password
```

The resulting password contains exactly 64 bytes.

The Keycloak administrative password was reset using the official `kcadm.sh` administration utility.

No PostgreSQL PVC or Keycloak database data was deleted during recovery.

### Keycloak Deployment

Keycloak 26.8.1 was deployed in the `identity` namespace.

The deployment uses PostgreSQL through the internal Kubernetes Service:

```text
postgresql.database.svc.cluster.local:5432
```

The initial startup failed because PostgreSQL rejected the password supplied by Keycloak.

After correcting the database password, Keycloak successfully connected to PostgreSQL, initialized its database schema, and completed the master realm bootstrap.

Validation confirmed:

- Keycloak Pod: `1/1 Running`
- Deployment: `1/1 Available`
- Internal Service: `ClusterIP`, port 8080
- PostgreSQL connectivity: successful
- Master realm initialization: successful

### DNS and Public Access

The following DNS records were configured to point to the AWS EC2 public IP:

- `keycloak.nst.art.br`
- `api.vocabulary.nst.art.br`
- `vocabulary.nst.art.br`

DNS resolution was verified using `dig`.

The public DNS records resolved to the AWS instance.

### cert-manager and Let's Encrypt

cert-manager version `v1.21.3` was installed using the official release manifest.

The installation created the required CRDs and the following components:

- cert-manager
- cert-manager-cainjector
- cert-manager-webhook

All three Deployments successfully reached their ready state.

A production ACME ClusterIssuer was configured:

- Name: `letsencrypt-prod`
- Certificate Authority: Let's Encrypt Production
- Challenge: HTTP-01
- Ingress Controller: Traefik

The ACME account was successfully registered.

### Keycloak HTTPS Ingress

A Kubernetes Ingress was created for:

```text
keycloak.nst.art.br
```

The Ingress uses Traefik and cert-manager annotations.

The certificate was successfully issued and stored in the Kubernetes Secret:

```text
identity/keycloak-tls
```

Certificate validation confirmed:

- Certificate: `keycloak-tls`
- Status: `Ready=True`
- Not Before: 2026-11-05
- Expiration: 2027-02-03
- Scheduled Renewal: 2027-01-04

The Keycloak deployment was configured with:

- HTTP enabled internally.
- Public HTTPS hostname.
- Forwarded proxy headers using `xforwarded`.

Public HTTPS validation returned:

```text
HTTP/2 302
location: https://keycloak.nst.art.br/admin/
```

The OpenID Connect discovery endpoint also returned the expected metadata, including the public HTTPS issuer:

```text
https://keycloak.nst.art.br/realms/master
```

This confirmed successful external access and correct issuer configuration.

### Administrative Account Recovery

The initial bootstrap administrator password contained a trailing newline, causing login failures.

The administrative session was recovered using the password stored in the running Keycloak container and the `kcadm.sh` utility.

A permanent administrative user named `cnl-admin` was created and enabled.

The administrative role configuration is still under investigation. The temporary bootstrap administrator must remain available until the permanent account has been fully validated.

The temporary account has not yet been removed.

### Lessons Learned

- Dedicated kubeconfig aliases help prevent accidental operations against unrelated Kubernetes clusters.
- Kustomize overlays provide a reusable way to separate local and AWS configurations.
- Password files generated by OpenSSL must be handled carefully because the default output includes a trailing newline.
- PostgreSQL initialization scripts execute only during initial database initialization.
- Keycloak bootstrap environment variables do not automatically reset credentials on subsequent restarts.
- `kcadm.sh` is useful for recovering and managing Keycloak administrative accounts.
- cert-manager can automate Let's Encrypt certificate issuance and renewal through HTTP-01 challenges.
- Traefik can terminate public HTTPS while Keycloak continues using HTTP internally.
- The public OpenID Connect issuer must match the externally accessible HTTPS hostname.

### Future Notes

The following tasks remain planned:

1. Complete permanent Keycloak administrator role assignment and remove the temporary bootstrap account after validation.
2. Review and harden public access to the Keycloak administration console.
3. Deploy the Vocabulary FastAPI backend.
4. Configure JWT validation between Vocabulary API and Keycloak.
5. Deploy the React frontend.
6. Configure public Ingress resources for the API and frontend.
7. Implement PostgreSQL backup and recovery procedures.
8. Review persistent storage and disk capacity on the EC2 instance.
9. Introduce GitOps reconciliation with ArgoCD after the application deployment structure is stable.

### Milestone

The Cloud Native Lab AWS Ohio environment successfully reached its first externally accessible identity service.

PostgreSQL is operational, Keycloak is connected to the database, and public HTTPS is working with an automatically managed Let's Encrypt certificate.

This establishes the identity and database foundation for the Vocabulary application deployment.

## 2026-11-05 — Private Container Registry and MinIO Community Deployment

### Objective

Establish a private container image registry and an S3-compatible object storage service inside the Cloud Native Lab AWS Ohio Kubernetes cluster.

The objective was to provide reusable infrastructure for application image distribution and object storage, preparing the environment for the deployment of the Vocabulary API and frontend.

### Environment

- Cloud provider: AWS
- Region: us-east-2 (Ohio)
- Kubernetes distribution: K3s
- Kubernetes version: v1.36.5+k3s1
- Node: cnl-aws-ohio-node01
- Operating system: Debian GNU/Linux 13 (Trixie)
- Container runtime: containerd
- Ingress controller: Traefik
- Certificate management: cert-manager
- Certificate issuer: Let's Encrypt production
- DNS domain: nst.art.br

### Private Container Registry

Deployed CNCF Distribution Registry 3 as the private container image registry for Cloud Native Lab.

Configuration:

- Namespace: registry
- Image: registry:3.1.2
- Replicas: 1
- Service type: ClusterIP
- Internal port: 5000
- Persistent storage: 5 GiB
- StorageClass: local-path
- Storage backend: filesystem
- Authentication: HTTP Basic Authentication using bcrypt
- External endpoint: https://registry.nst.art.br
- TLS: cert-manager with Let's Encrypt
- Ingress controller: Traefik

The registry uses a persistent volume claim named registry-data and stores image layers in the filesystem.

Authentication is configured through a Kubernetes Secret generated from a local htpasswd file. The internal registry HTTP secret is also stored in a Kubernetes Secret.

Both credential files are excluded from Git through .gitignore.

The registry is independent of MinIO, avoiding a circular dependency between image distribution and object storage.

### Registry Validation

The deployment was validated successfully:

- Registry Pod reached Running state.
- Persistent volume claim reached Bound state.
- Internal ClusterIP Service was created.
- Ingress was configured for registry.nst.art.br.
- HTTPS access was successfully established.
- Unauthenticated API requests returned HTTP 401.
- Authenticated requests using registry-admin returned HTTP 200.
- Docker authentication and subsequent image push/pull testing were prepared as the registry usage workflow.

The registry endpoint is:

https://registry.nst.art.br

Image naming convention:

registry.nst.art.br/<application>:<version>

Examples:

- registry.nst.art.br/vocabulary-api:<version>
- registry.nst.art.br/vocabulary-front:<version>
- registry.nst.art.br/minio-community:<version>

### MinIO Community Image

Created a dedicated Dockerfile to build MinIO Community from its official source repository.

The build process uses a multi-stage Docker image:

- Build environment: Go 1.24.8
- Runtime environment: Debian 13 slim
- Source repository: github.com/minio/minio
- Source revision: 7aac2a2c5b7c882e68c1ce017d8256be2feea27f

The resulting image was published to the private registry using the tag:

registry.nst.art.br/minio-community:7aac2a2

The image reported the following application version during validation:

DEVELOPMENT.2026-02-12T20-18-48Z

This build is based on the MinIO Community source code. The upstream repository was archived in April 2026, so this deployment requires maintaining the build process and evaluating future security and compatibility risks.

### MinIO Kubernetes Deployment

Deployed MinIO Community as a single-replica StatefulSet.

Configuration:

- Namespace: storage
- Workload: StatefulSet
- Replicas: 1
- S3 API port: 9000
- Console port: 9001
- Service type: ClusterIP
- Persistent storage: 10 GiB
- StorageClass: local-path
- Storage backend: filesystem
- Image registry: registry.nst.art.br

The deployment uses a dedicated Kubernetes Secret for MinIO root credentials.

A separate imagePullSecret provides Kubernetes access to the private container registry.

Two Services were configured:

- minio: S3 API and administrative console.
- minio-headless: StatefulSet network identity.

The S3 API is internally accessible through:

http://minio.storage.svc.cluster.local:9000

The administrative console is available through port-forwarding:

kubectl-aws port-forward -n storage svc/minio 9001:9001

No public Ingress was created for MinIO. Both interfaces remain internal to the cluster, reducing unnecessary external exposure.

### MinIO Validation

The deployment was validated successfully:

- MinIO StatefulSet reached Running state.
- MinIO Pod reached 1/1 Ready.
- Persistent volume claim was provisioned and Bound.
- MinIO logs confirmed successful initialization.
- S3 API started on port 9000.
- Web console started on port 9001.
- Administrative console access was confirmed using the locally stored root credentials.

### Secret Management

Sensitive values are stored locally and generated as Kubernetes Secrets.

Registry credentials:

- registry-auth
- registry-runtime

MinIO credentials:

- minio-credentials

Image pull credentials:

- registry-pull-credentials

Secret source files are stored under the respective AWS overlay secrets directories.

The .gitignore configuration excludes these files from version control while preserving .gitkeep placeholders.

No passwords or authentication tokens are committed to the repository.

### Storage and Availability Considerations

Both services use the K3s local-path StorageClass.

Registry storage allocation: 5 GiB.

MinIO storage allocation: 10 GiB.

The current AWS EC2 instance has a 40 GiB EBS volume.

The local-path provisioner does not support dynamic PVC expansion through Kubernetes in the current configuration. Storage capacity must therefore be monitored at the node filesystem level.

Both services run as single replicas on a single K3s node. They do not provide high availability or node-level storage redundancy.

Future storage improvements may include Longhorn or another storage backend with volume expansion and replication capabilities.

### Git and Version Control

The implementation was consolidated in the feature branch:

feature/private-registry-minio

Implementation commits:

- dab5f7e — feat(kubernetes): deploy private container registry
- 544d4ee — feat(kubernetes): deploy private registry and MinIO

The implementation was integrated into develop and subsequently promoted to main.

Release merge commit:

- 7580dcf — release: deploy private registry and MinIO

### Lessons Learned

- A private registry provides a central image distribution point for all application repositories.
- Keeping the registry independent of MinIO avoids circular service dependencies.
- Image pull credentials must be configured separately inside Kubernetes.
- Registry authentication must be protected by HTTPS.
- Locally generated secrets must remain outside Git.
- Persistent volumes are essential for registry layers and object storage.
- Single-node local-path storage is suitable for the initial environment but does not provide high availability.
- Building MinIO from source requires pinning the source revision and maintaining a reproducible build process.

### Future Notes

- Configure automated image builds and publishing through GitHub Actions.
- Establish image versioning conventions for application repositories.
- Create dedicated MinIO application credentials with restricted permissions.
- Create the vocabulary bucket.
- Validate S3 operations, including bucket creation, upload, download and persistence.
- Integrate MinIO with vocabulary-api.
- Deploy the Vocabulary API using the private registry.
- Deploy the Vocabulary frontend using the private registry.
- Evaluate storage expansion and backup strategies.

### Milestone

Private container image distribution and S3-compatible object storage are now available in the Cloud Native Lab AWS Ohio cluster.

The infrastructure is prepared for the next milestone: deploying the Vocabulary API with PostgreSQL, MinIO and Keycloak integration.

## 2026-11-06 — Vocabulary Authentication, AI Generation and Media Fixes

### Objective

Resolve the HTTP 401 errors between the Vocabulary frontend and API, then restore the features that the 401 had hidden: category and text generation, and word images and audio.

### Root Causes

| Symptom | Cause | Evidence |
|---|---|---|
| 401 with "bearer token is required" | The running frontend image had no Axios interceptor | No `Bearer` in the served bundle; no introspection event in Keycloak |
| 401 with "token invalid or expired" | `vocabulary-api-admin` was not in the token audience | Keycloak `INTROSPECT_TOKEN_ERROR`: "Client 'vocabulary-api-admin' is not in the token audience" |
| 500 on category and text generation | The hard-coded OpenRouter model was retired | `KeyError: 'choices'`; OpenRouter returned HTTP 404 for the model |
| Word and text media did not load | Presigned URLs used the internal cluster endpoint | Generated URLs pointed to `minio.storage.svc.cluster.local` |

Frontend image `0.0.1` also crashed as non-root because it lacked the `/tmp` nginx configuration. While the rollout was stuck, the previous `0.0.4` pod kept serving traffic.

### Keycloak Configuration

This configuration exists only in Keycloak and must be recreated if the realm is rebuilt.

- Realm: `Vocabulary`
- Location: Clients → `vocabulary-app` → Client scopes → `vocabulary-app-dedicated` → Mappers
- Mapper type: Audience
- Name: `aud-vocabulary-api-admin`
- Included Client Audience: `vocabulary-api-admin`
- Included Custom Audience: empty
- Add to access token: ON

Issued access tokens must contain exactly `vocabulary-api-admin` in `aud`. A trailing space in the value was found during this work, so check the value in Client scopes → Evaluate.

### Deployed Versions

| Component | Version | Digest prefix |
|---|---|---|
| vocabulary-app | 0.0.5 | `33cf06ce755a` |
| vocabulary-api | 0.0.3 | `69fd0291994c` |

The API ConfigMap now sets `OPENROUTER_MODEL` to `nvidia/nemotron-3.5-lightning:free`.

### Validation

- Frontend requests returned HTTP 200 and Keycloak logged no introspection errors.
- Categories, words and texts were created through the application.
- Word images and audio were confirmed working in the browser by the user.

### Git and Version Control

- my-vocabulary: 6fa7da3 — chore: new deploy
- vocabulary-api: 9246a78 — fix(openrouter): replace retired model and surface HTTP errors
- vocabulary-api: fa58b01 — fix(media): presign browser URLs with the public S3 endpoint
- cloud-native-lab: f151062 — fix(kubernetes): deploy vocabulary authentication and media fixes

Images `vocabulary-api:0.0.2` and `0.0.3` were built from the uncommitted working tree before these commits, so their revision label ends in `-dirty`.

### Lessons Learned

- Compare the served bundle with the source; the Git history alone did not show what was running.
- Keycloak events give the exact introspection failure, while API logs only show the 401.
- A client that reads a response without checking its status hides the real upstream error.
- Free AI models can be retired or rate limited without notice, so the model should remain configurable.
- Presigned URLs must be signed for the host the browser will use.

### Future Notes

- Evaluate a dedicated introspection client instead of `vocabulary-api-admin` in the token audience.
- Rebuild the API image from a committed revision at the next release.
- Disable SQLAlchemy statement logging, which writes user identifiers to the API logs.
- Resolve the circular import between `get_words_by_user` and `app.modules`.
- Review Registry tags against the images in use before any further cleanup.

### End-of-Day Status

The application is working in production, but the source of its running versions has not been published yet.

| Repository | Branch | Local | Remote branch | Status |
|---|---|---|---|---|
| my-vocabulary | main | 6fa7da3 | 6fa7da3 | Published; no `develop` branch on the remote |
| vocabulary-api | feature/vocabulary-api-container | fa58b01 | 722568b | Two commits not pushed; `main` is at 3f5c874 and there is no remote `develop` |
| cloud-native-lab | feature/vocabulary-auth-media-fixes | this branch | Not created | Not pushed; `main` is at 09dc293 and `develop` at f4d8c27 |

Registry tags found by direct lookup:

| Image | Tags present | In use |
|---|---|---|
| vocabulary-app | 0.0.1, 0.0.2, 0.0.3, 0.0.4, 0.0.5 | 0.0.5 |
| vocabulary-api | 0.0.1, 0.0.2, 0.0.3 | 0.0.3 |
| minio-community | 7aac2a2 | Not checked in this work |

The earlier cleanup of `vocabulary-app` tags `0.0.2` to `0.0.4` is not reflected in the Registry. Tag `0.0.1` cannot run under the current non-root Deployment.

Do not run `kubectl-aws apply -k` from `main` until this branch is merged, because `main` still has `vocabulary-app:0.0.4` and `vocabulary-api:0.0.1`.

### Next Steps

1. Push the `vocabulary-api` and `cloud-native-lab` branches.
2. Merge the `cloud-native-lab` branch into `develop`, then promote it to `main`.
3. Confirm that `kubectl-aws diff -k` from `main` reports no changes.
4. Define how `vocabulary-api` reaches `main`, since its deployed code is only on a feature branch.
5. Decide which Registry tags to keep, then clean up without removing images in use or rollback targets.
6. Build the next API image from a committed revision and turn off SQLAlchemy statement logging.

### Publication Update — 2026-11-07

- vocabulary-api: `feature/vocabulary-api-container` was merged into `main` with a merge commit. The remote has no `develop` branch, and the GitHub CLI was not available for a pull request.
- cloud-native-lab: this branch was merged into `develop` and promoted to `main`.
- Before the merge, `kubectl-aws diff -k` against these manifests reported no changes, so applying from `main` now matches production.
- my-vocabulary already had the frontend change on `main`.

Still pending: Registry cleanup, and the next API image built from a committed revision with SQLAlchemy statement logging disabled.

### Registry Cleanup — 2026-11-07

Unused Vocabulary tags were deleted with user approval. Before deletion, each tag was confirmed unused by every pod in the cluster and its digest was compared with the kept tags.

| Image | Deleted | Kept |
|---|---|---|
| vocabulary-app | 0.0.1, 0.0.2, 0.0.3 | 0.0.4 (rollback), 0.0.5 (in use) |
| vocabulary-api | 0.0.1 | 0.0.2 (rollback), 0.0.3 (in use) |
| minio-community | — | 7aac2a2 |

- Tags were deleted by digest through the Registry API, and each request returned HTTP 202.
- Deletion is enabled by `storage.delete.enabled: true` in the image's default `/etc/distribution/config.yml`, so no Registry configuration change was needed.
- Garbage collection has not run, so the deleted layers still use disk space (174.6 MiB in total after deletion, against a 5 GiB volume). It requires putting the Registry in read-only mode and restarting it.

## 2026-11-12 — Vocabulary API 0.0.4 and Registry Garbage Collection Assessment

### Objective

Close the two items left open on 2026-11-07: build the next API image from a committed revision with SQLAlchemy statement logging disabled, and assess Registry garbage collection.

### Cluster Access

At first, `kubectl-aws` timed out when connecting to the Kubernetes API on port 6443, although the public HTTPS endpoints still responded. The administrator's public IP had changed, and the AWS security group allows 6443 only from the administrator address. Access returned after the rule was updated.

Lesson: when `kubectl-aws` times out but the applications respond, check the administrator IP rule first.

### SQL Statement Logging

- vocabulary-api `app/core/config.py` now creates the engine with `echo=False`. Statement logging had written every query and its parameters, including user identifiers, to the production logs.
- Commit `cb7fe1d`, merged into `develop` and promoted to `main` at `e1ff01a`.

### Vocabulary API 0.0.4

- Built from a `git archive` export of `e1ff01a`, so ignored local files cannot enter the image.
- `org.opencontainers.image.revision` is set to the full commit, without the `-dirty` suffix carried by 0.0.2 and 0.0.3.
- Checked before the push: it runs as `appuser`, contains no `.env` file, and `app.main` imports.
- Before applying, `kubectl-aws diff -k` showed only the image tag change.
- The rollout completed, `/docs` returned HTTP 200, and the startup logs contained no SQL statements.
- Rollback: set the tag back to `0.0.3` in `base/vocabulary/api/deployment.yaml` and apply again.

### Registry Garbage Collection

- A dry-run (`registry garbage-collect --dry-run`) found 36 blobs marked and 12 blobs eligible for deletion, about 0.4 MB of the 174.7 MB in use.
- The tags deleted on 2026-11-07 shared almost all their layers with the kept tags.
- The real collection needs a read-only window and two restarts, so it was not run. Revisit it after removing more tags. The candidates are vocabulary-api 0.0.2 and 0.0.3, which carry `-dirty` labels.

### Git Workflow

After a `feature/*` or `docs/*` branch is merged and promoted to `main`, it is deleted locally and on the remote, and `develop` is kept equal to `main`. All four repositories follow this pattern. The only exception is `new_sidebar` in my-vocabulary, which was kept deliberately.

### Current Versions

| Component | Version |
|---|---|
| vocabulary-app | 0.0.5 |
| vocabulary-api | 0.0.4 |
