# PostgreSQL User Management Guide

## 1. Purpose

This guide describes how to create and manage dedicated PostgreSQL users for applications running in the Cloud Native Lab Kubernetes environment.

The recommended approach is to create one database user per application, following the principle of least privilege.

Examples:

| Application | Database | PostgreSQL User |
|---|---|---|
| Keycloak | keycloak | keycloak_user |
| Vocabulary | vocabulary | vocabulary_user |

## 2. Environment

- Kubernetes namespace: `database`
- StatefulSet: `postgresql`
- Pod: `postgresql-0`
- Administrative user: `postgres_admin`
- PostgreSQL version: 18.6

Always use the `kubectl-cnl` alias to interact with the Cloud Native Lab cluster.

## 3. Connect to PostgreSQL

Open an interactive PostgreSQL session:

```bash
kubectl-cnl exec -it -n database postgresql-0 -- \
  psql -U postgres_admin -d postgres_admin
```

The expected prompt is:

```text
postgres_admin=#
```

## 4. Create an application user

Create a login role:

```sql
CREATE ROLE keycloak_user LOGIN;
```

Expected result:

```text
CREATE ROLE
```

### Set the password

Use PostgreSQL's interactive password command:

```sql
\password keycloak_user
```

Enter the password twice when prompted.

**Security recommendations:**

- Generate a unique password for each application.
- Use a password manager or a securely stored local password file.
- Never commit passwords to Git.
- Never include passwords in SQL scripts or documentation.
- Do not share credentials in chat messages or logs.

## 5. Verify the role

List the role:

```sql
\du keycloak_user
```

The role should exist without superuser privileges.

## 6. Create the application database

Create a database owned by the dedicated application user:

```sql
CREATE DATABASE keycloak OWNER keycloak_user;
```

This makes `keycloak_user` the owner of the database.

The application should not use the PostgreSQL administrative account.

## 7. Verify database ownership

Run:

```sql
\l keycloak
```

Check that the database owner is `keycloak_user`.

You can also inspect roles:

```sql
\du
```

## 8. Exit PostgreSQL

To leave the interactive PostgreSQL session:

```sql
\q
```

## 9. Troubleshooting

### Accidental unfinished SQL command

If the prompt changes from:

```text
postgres_admin=#
```

to:

```text
postgres_admin-#
```

PostgreSQL is waiting for the rest of an incomplete SQL statement.

To cancel the current statement:

```sql
\r
```

The prompt should return to:

```text
postgres_admin=#
```

### Check whether a role already exists

```sql
SELECT rolname, rolsuper, rolcreatedb, rolcanlogin
FROM pg_roles
WHERE rolname = 'keycloak_user';
```

Avoid executing `CREATE ROLE` again if the role already exists.

### Change an existing user's password

```sql
\password keycloak_user
```

This allows password rotation without putting the password directly into SQL history.

## 10. Operational Security Rules

1. Never use the PostgreSQL administrative account in application connection strings.
2. Create one dedicated login role per application.
3. Give each application ownership of its own database.
4. Do not grant superuser privileges to application users.
5. Keep credentials outside Git tracking.
6. Store Kubernetes Secrets in the namespace where the application runs.
7. Use SCRAM-SHA-256 for network authentication.
8. Rotate credentials when exposure is suspected.
9. Maintain database backups.

## 11. Example Connection Parameters

For Keycloak:

```text
Host: postgresql.database.svc.cluster.local
Port: 5432
Database: keycloak
Username: keycloak_user
Password: stored in Kubernetes Secret
```

The password must be supplied through the application's Kubernetes Secret, not hardcoded in its Deployment or ConfigMap.