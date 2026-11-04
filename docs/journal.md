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