# Keycloak Deployment Guide

## 1. Overview

This guide documents the deployment, configuration, operation, and recovery procedures for Keycloak in the Cloud Native Lab platform.

Keycloak provides identity and access management (IAM) for platform applications.

The deployment uses Kubernetes, Kustomize, and PostgreSQL for persistent storage.

### Technology Stack

| Component | Version / Configuration |
|---|---|
| Kubernetes | K3s |
| Keycloak | 26.8.1 |
| PostgreSQL | 18.6 |
| Deployment strategy | Kubernetes Deployment |
| Replicas | 1 |
| Service type | ClusterIP |
| Configuration | Kustomize |
| Secrets | Kubernetes Secret |

## 2. Architecture

Keycloak runs in the `identity` namespace and connects to PostgreSQL in the `database` namespace.

```text
K3s Cluster
│
├── database
│   └── PostgreSQL
│       ├── Service: postgresql
│       └── Database: keycloak
│
└── identity
    └── Keycloak
        ├── Deployment: keycloak
        ├── Service: keycloak
        └── Secret: keycloak-credentials
```

### PostgreSQL Connection

| Parameter | Value |
|---|---|
| Host | postgresql.database.svc.cluster.local |
| Port | 5432 |
| Database | keycloak |
| Username | keycloak_user |

The database credentials are stored in a Kubernetes Secret.

## 3. Repository Structure

```text
platform/kubernetes/
├── base/
│   └── keycloak/
│       ├── kustomization.yaml
│       ├── namespace.yaml
│       ├── deployment.yaml
│       └── service.yaml
│
└── overlays/
    └── local/
        └── keycloak/
            ├── kustomization.yaml
            └── secrets/
                ├── keycloak-admin-password
                └── keycloak-db-password
```

The base directory contains reusable Kubernetes resources.

The local overlay provides environment-specific configuration and generates the Kubernetes Secret.

## 4. Secret Management

Two passwords are required:

- `keycloak-db-password`: PostgreSQL authentication for `keycloak_user`.
- `keycloak-admin-password`: Initial Keycloak bootstrap administrator password.

These files must remain outside Git.

Verify Git protection:

```bash
git check-ignore -v \
  platform/kubernetes/overlays/local/keycloak/secrets/keycloak-admin-password \
  platform/kubernetes/overlays/local/keycloak/secrets/keycloak-db-password
```

Set restrictive permissions:

```bash
chmod 600 platform/kubernetes/overlays/local/keycloak/secrets/*
```

**Important:** The bootstrap administrator environment variables are used during initial initialization. Changing their values later does not automatically reset an existing administrator password.

## 5. Deployment

Always use the dedicated Cloud Native Lab kubectl alias.

Validate the manifests:

```bash
kubectl-cnl kustomize platform/kubernetes/overlays/local/keycloak
```

Apply the configuration:

```bash
kubectl-cnl apply -k platform/kubernetes/overlays/local/keycloak
```

Check deployment status:

```bash
kubectl-cnl get pods,svc -n identity
```

Check rollout:

```bash
kubectl-cnl rollout status deployment/keycloak -n identity
```

## 6. Accessing Keycloak

The Keycloak Service is internal to the Kubernetes cluster.

Service DNS:

```text
keycloak.identity.svc.cluster.local
```

Service port:

```text
8080
```

For local workstation access, use port forwarding:

```bash
kubectl-cnl port-forward -n identity svc/keycloak 8080:8080
```

Open:

```text
http://localhost:8080/admin/
```

The initial bootstrap administrator is not intended to be the permanent operational account.

A permanent administrator account named `cnl-admin` was created in the `master` realm.

## 7. Health Checks and Troubleshooting

Check pod status:

```bash
kubectl-cnl get pods -n identity
```

Inspect application logs:

```bash
kubectl-cnl logs deployment/keycloak -n identity --tail=100
```

Check the management health endpoint:

```bash
kubectl-cnl exec -n identity deployment/keycloak -- \
  /bin/bash -c 'exec 3<>/dev/tcp/127.0.0.1/9000 && echo -e "GET /health/ready HTTP/1.1\r\nHost: localhost\r\nConnection: close\r\n\r\n" >&3 && cat <&3'
```

Expected response:

```text
HTTP/1.1 200 OK
```

The health response should report:

```json
{
  "status": "UP"
}
```

## 8. Administrator Recovery

If administrator access is lost, Keycloak provides an official recovery procedure.

### 8.1 Stop Keycloak

```bash
kubectl-cnl scale deployment/keycloak -n identity --replicas=0
```

Confirm no Keycloak pods remain:

```bash
kubectl-cnl get pods -n identity
```

### 8.2 Create a temporary recovery password

Generate a password locally and store it in a Kubernetes Secret.

Never commit the password or expose it in logs.

### 8.3 Execute the recovery command

Use the official Keycloak image and the existing PostgreSQL connection settings.

The recovery command is:

```bash
/opt/keycloak/bin/kc.sh bootstrap-admin user \
  --username temp-admin \
  --password:env=TEMP_ADMIN_PASSWORD \
  --no-prompt
```

The recovery process must connect to the existing Keycloak database.

### 8.4 Restore Keycloak

After successful recovery:

```bash
kubectl-cnl scale deployment/keycloak -n identity --replicas=1
```

Check readiness:

```bash
kubectl-cnl rollout status deployment/keycloak -n identity
```

Log in with the temporary administrator and create a permanent administrator account.

Delete the temporary administrator after confirming permanent access.

Remove temporary Kubernetes resources:

```bash
kubectl-cnl delete job keycloak-admin-recovery -n identity
kubectl-cnl delete secret keycloak-recovery-credentials -n identity
```

**Never delete the PostgreSQL database or PVC as part of administrator recovery.**

The temporary administrator has a limited lifetime. Complete the recovery promptly.

## 9. Security Considerations

Current deployment characteristics:

- Keycloak is exposed through an internal ClusterIP Service.
- HTTP is enabled for initial local access.
- External HTTPS and Ingress are not yet configured.
- Credentials are stored in Kubernetes Secrets.
- Password files are excluded from Git.
- PostgreSQL is accessed through internal cluster DNS.

Before external exposure, configure:

- A stable Keycloak hostname.
- HTTPS.
- Correct reverse-proxy headers.
- Appropriate hostname validation.
- Secure cookie settings.

Do not expose the current HTTP endpoint publicly.

## 10. Future Improvements

Planned improvements:

- Traefik Ingress integration.
- HTTPS using cert-manager.
- Stable DNS hostname.
- Automated PostgreSQL backups.
- Keycloak realm configuration and application clients.
- GitOps management through ArgoCD.
- Production-grade secret management.
- High availability when the cluster architecture supports it.
