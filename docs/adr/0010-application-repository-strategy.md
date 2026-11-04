# ADR-0010 — Application Repository Strategy and Local Kubernetes Deployment

**Status:** Accepted

**Date:** 2026-11-04

**Decision Makers:** Cloud Native Lab

**Related ADRs:** ADR-0001, ADR-0009

---

## 1. Context

The Cloud Native Lab project includes multiple application development initiatives that require a common infrastructure and deployment platform.

One of these initiatives is the Vocabulary application, which currently consists of three independent Git repositories:

- `vocabulary-api` — Backend application based on Python and FastAPI.
- `my-vocabulary` — Web frontend based on React.
- `vocabulary-mobile` — Mobile application based on React Native.

Although these repositories represent different application components, they are part of the same application ecosystem and depend on shared infrastructure services.

The Vocabulary application requires the following components:

- Keycloak for identity and access management.
- PostgreSQL for relational data persistence.
- MinIO for object storage.
- FastAPI for backend services.
- React for the web frontend.
- React Native for the mobile application.

The initial implementation used Docker-based infrastructure to run the supporting services and application components.

As the Cloud Native Lab evolves towards Kubernetes and GitOps, a strategy is required to integrate these existing projects without unnecessarily coupling their development lifecycles.

The architecture must support:

- Independent application development.
- Independent source code versioning.
- Reusable container images.
- Centralized infrastructure management.
- Declarative Kubernetes deployments.
- Progressive adoption of GitOps.
- Local development and validation before remote deployment.

The solution must remain simple during the initial implementation while allowing additional applications and services to be integrated in the future.

---

## 2. Decision

The Cloud Native Lab will maintain independent application repositories and use the `cloud-native-lab` repository as the central source of infrastructure and deployment configurations.

The project will adopt a repository separation strategy based on the following responsibilities:

1. Application source code.
2. Infrastructure and deployment configuration.

The Vocabulary application repositories will remain independent and will not be merged into a monorepo.

The `cloud-native-lab` repository will be responsible for Kubernetes manifests, infrastructure configuration and future GitOps integration.

### 2.1 Application Repository Independence

The following repositories will remain independent:

| Repository | Responsibility | Technology |
|---|---|---|
| `vocabulary-api` | Backend application | Python / FastAPI |
| `my-vocabulary` | Web frontend | React |
| `vocabulary-mobile` | Mobile application | React Native |
| `cloud-native-lab` | Infrastructure and deployment | Terraform, Ansible, Kubernetes, ArgoCD |

Each application repository will maintain its own:

- Source code.
- Dependencies.
- Tests.
- Development workflow.
- Version history.
- Build configuration.
- CI/CD pipeline.

Application repositories must not depend on the internal directory structure of the Cloud Native Lab repository.

### 2.2 Infrastructure and Deployment Ownership

The `cloud-native-lab` repository will be responsible for managing the infrastructure required to run the applications.

This includes:

- Kubernetes namespaces.
- Deployments and StatefulSets.
- Services.
- Ingress resources.
- Persistent Volume Claims.
- ConfigMaps.
- Secret references.
- Kustomize configurations.
- ArgoCD applications.

Application source code will not be copied into the infrastructure repository.

Container images will be built and published independently by the respective application repositories.

Kubernetes deployment configurations will reference the published application images.

### 2.3 Local Kubernetes Deployment

The initial Vocabulary deployment will use the local infrastructure environment established by ADR-0009.

The first deployment target will be the Debian 13 virtual machine provisioned through KVM and Libvirt.

The local environment will be used to validate:

- Kubernetes installation and configuration.
- Application deployment.
- Service discovery.
- Internal networking.
- Persistent storage.
- Authentication integration.
- Application connectivity.
- Container runtime behavior.

RKE2 will be used as the initial Kubernetes distribution for this environment.

The local deployment will serve as the primary validation environment before introducing additional remote infrastructure.

### 2.4 Application Architecture

The Vocabulary application will initially consist of the following components:

| Component | Technology | Deployment |
|---|---|---|
| Web Frontend | React | Kubernetes |
| Backend API | FastAPI | Kubernetes |
| Identity Provider | Keycloak | Kubernetes |
| Relational Database | PostgreSQL | Kubernetes |
| Object Storage | MinIO | Kubernetes |
| Mobile Application | React Native | External application |

The mobile application will remain independent of the Kubernetes deployment lifecycle.

It will consume the backend API through an externally accessible application endpoint.

PostgreSQL will initially support the application and Keycloak, using logically separated databases and credentials.

Storage persistence and backup requirements must be considered when implementing stateful services.

### 2.5 Kubernetes Organization

The initial implementation will organize the Vocabulary application within a dedicated Kubernetes namespace:

`vocabulary`

Application resources will be grouped by component to simplify maintenance and future evolution.

Kustomize will be used for the initial Kubernetes manifest organization.

Helm Charts and additional deployment abstractions may be introduced later when justified by operational requirements.

### 2.6 GitOps Evolution

ArgoCD will be introduced as the GitOps deployment controller.

The intended deployment workflow will be:

1. Application source code is updated.
2. The application repository executes its CI pipeline.
3. A container image is built and published.
4. The deployment configuration references the new image version.
5. ArgoCD detects the configuration change.
6. Kubernetes reconciles the desired application state.

The `cloud-native-lab` repository will remain the source of truth for infrastructure and Kubernetes deployment configurations.

The specific container registry and image promotion strategy will be defined in future implementation decisions.

---

## 3. Repository and Deployment Architecture

The expected repository organization is:

```text
GitHub
|
+-- cloud-native-lab/
|   |
|   +-- infrastructure/
|   |   +-- terraform/
|   |   +-- ansible/
|   |   +-- virtualization/
|   |
|   +-- kubernetes/
|   |   +-- platform/
|   |   |
|   |   +-- applications/
|   |       +-- vocabulary/
|   |           +-- namespace.yaml
|   |           +-- api/
|   |           +-- frontend/
|   |           +-- keycloak/
|   |           +-- postgres/
|   |           +-- minio/
|   |
|   +-- docs/
|   |
|   +-- README.md
|
+-- vocabulary-api/
|   +-- app/
|   +-- tests/
|   +-- Dockerfile
|   +-- ...
|
+-- my-vocabulary/
|   +-- src/
|   +-- public/
|   +-- Dockerfile
|   +-- ...
|
+-- vocabulary-mobile/
    +-- src/
    +-- android/
    +-- ...
```

The expected application communication architecture is:

```text
                 VOCABULARY APPLICATION
                            |
                            |
                    Kubernetes Cluster
                            |
                       Traefik Ingress
                            |
             +--------------+--------------+
             |              |              |
             v              v              v
          Frontend        Backend       Keycloak
           React          FastAPI       Identity
             |              |              |
             |              +------+-------+
             |                     |
             |             +-------+-------+
             |             |               |
             |             v               v
             |         PostgreSQL        MinIO
             |         Persistence    Object Storage
             |
             |
        Mobile Application
         React Native
             |
             v
          Backend API
```

The diagram represents the logical application architecture. Actual network exposure, authentication flows and service communication will be defined during implementation.

---

## 4. Alternatives Considered

### 4.1 Monorepo Architecture

Combining all application source code and infrastructure configurations into a single repository was considered.

This approach was not selected because the existing projects already have independent repositories and development lifecycles.

A monorepo would introduce additional coupling between components that can evolve independently.

Maintaining separate repositories provides clearer ownership and independent versioning.

### 4.2 Independent Infrastructure Repositories

Creating a separate infrastructure repository for each application component was considered.

This approach was not selected because it would distribute Kubernetes deployment configurations across multiple repositories.

The Cloud Native Lab already serves as the central infrastructure management repository.

Centralizing deployment configurations simplifies GitOps integration and operational visibility.

### 4.3 Direct Deployment from Application Repositories

Allowing application repositories to manage their own Kubernetes manifests and deployments was considered.

This approach was not selected as the default strategy because it would mix application development responsibilities with infrastructure management.

Application repositories will remain responsible for building and publishing images, while the Cloud Native Lab will manage their deployment configurations.

### 4.4 Local Docker Compose as the Long-Term Deployment Platform

Continuing to use Docker Compose as the primary deployment architecture was considered.

This approach was not selected as the long-term direction because the Cloud Native Lab aims to develop practical Kubernetes, Platform Engineering and GitOps capabilities.

Docker Compose may still be used for local application development and isolated testing.

Kubernetes will be the target platform for the Cloud Native Lab deployment architecture.

---

## 5. Consequences

### Positive Consequences

- Independent application development and versioning.
- Clear separation between application code and infrastructure.
- Centralized Kubernetes deployment management.
- Simplified GitOps integration.
- Reusable application container images.
- Reduced coupling between application components.
- Improved infrastructure portability.
- Progressive migration from Docker-based environments to Kubernetes.
- Consistent deployment practices across future applications.
- Better architectural organization and maintainability.
- Improved opportunities for practical Platform Engineering experience.

### Negative Consequences

- Multiple repositories require independent maintenance.
- Application and infrastructure changes must be coordinated.
- Image version updates introduce an additional deployment workflow.
- Centralized deployment management requires clear ownership and documentation.
- Stateful services introduce storage and backup responsibilities.
- Local Kubernetes resources are limited by workstation capacity.
- Additional operational complexity compared with a simple Docker Compose environment.

---

## 6. Security and Configuration Principles

The application deployment architecture will follow these principles:

- Application secrets must not be committed to Git.
- Sensitive configuration must be managed through Kubernetes Secrets or an explicitly adopted secret management solution.
- Application images must use explicit versions rather than relying on mutable tags such as `latest`.
- Database credentials must be separated between application components.
- External access must be controlled through ingress and appropriate security policies.
- Persistent application data must be protected through suitable backup procedures.
- Container images and dependencies should be reviewed for vulnerabilities.
- Administrative access to the Kubernetes environment must remain restricted.

Production secret management and access policies will be defined separately when the production environment is implemented.

---

## 7. Implementation Roadmap

The application integration will follow these milestones:

| Stage | Milestone | Status |
|---|---|---|
| 1 | Maintain independent application repositories | Accepted |
| 1 | Establish local Debian 13 virtualization | Completed |
| 1 | Configure Ansible bootstrap automation | Completed |
| 1 | Install Docker Engine through Ansible | Completed |
| 1 | Review existing application Dockerfiles | Planned |
| 1 | Prepare local RKE2 environment | Planned |
| 1 | Create Vocabulary Kubernetes namespace | Planned |
| 1 | Deploy PostgreSQL | Planned |
| 1 | Deploy MinIO | Planned |
| 1 | Deploy Keycloak | Planned |
| 1 | Deploy FastAPI backend | Planned |
| 1 | Deploy React frontend | Planned |
| 1 | Validate mobile application integration | Planned |
| 2 | Publish application images through CI/CD | Planned |
| 2 | Integrate ArgoCD | Planned |
| 2 | Implement GitOps deployment workflow | Planned |
| 3 | Evaluate remote deployment | Future |
| 3 | Integrate cloud infrastructure | Future |

Milestone status must be updated as implementation progresses.

---

## 8. References

- ADR-0001 — Project Principles.
- ADR-0009 — Multi-Cloud Strategy and Infrastructure Evolution.
- `infrastructure/virtualization/`
- `infrastructure/ansible/`
- `kubernetes/`
- `docs/architecture.md`
- `docs/roadmap.md`

---