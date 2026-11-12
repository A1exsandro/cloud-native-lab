# Runbook: Update the Administrator IP for Cluster Access

Administrative access to the AWS instance is restricted to a single public IPv4 address (`admin_cidr`, a `/32`). When the administrator's public IP changes, typically after a home router or ISP reconnect, administrative access stops working until the rule is updated.

Related: [ADR-0008 — AWS Security Groups Strategy](../../adr/0008-aws-security-groups-strategy.md).

## Symptoms

- `kubectl-aws` fails with `dial tcp ...:6443: i/o timeout`.
- SSH to the instance times out.
- The public applications (`https://vocabulary.nst.art.br`, the API, Keycloak and the Registry) **still respond**. Ports 80 and 443 are open to everyone, while ports 22 and 6443 are restricted to `admin_cidr`.

If the public applications are also down, the problem is not the administrator IP. Check the instance state instead.

## Where the Rule Lives

| Item | Value |
|---|---|
| Terraform code | `infrastructure/terraform/environments/aws/security-groups.tf` |
| Variable | `admin_cidr`, declared in `security-groups.tf` |
| Security group | `cloud-native-lab-ec2-sg` (`aws_security_group.ec2`) |
| Restricted ports | TCP 22 (SSH) and TCP 6443 (Kubernetes API) |
| Region | `us-east-2` |

The value of `admin_cidr` is set in `terraform.tfvars`, which is git-ignored. The Terraform state is local and not committed. Run Terraform from the working directory that holds both files.

Never commit `terraform.tfvars`, state files or IP addresses.

## Procedure

### 1. Confirm that the IP changed

```bash
curl -s https://checkip.amazonaws.com
```

Compare it with `admin_cidr` in your local `terraform.tfvars`. Do not paste either value into issues, commits or chat.

### 2. Update the rule with Terraform (preferred)

In the Terraform working directory for the AWS environment:

1. Set `admin_cidr = "<new-ip>/32"` in `terraform.tfvars`.
2. Review the plan:

   ```bash
   terraform plan
   ```

   The plan should show only an in-place update of `aws_security_group.ec2`, changing the `cidr_blocks` of the port 22 and port 6443 ingress rules. If the plan wants to replace or destroy anything else, stop and investigate.

3. Apply:

   ```bash
   terraform apply
   ```

### 3. Emergency alternative: the AWS console

To edit the rule by hand in the console: open EC2, then Security Groups, then `cloud-native-lab-ec2-sg`, then Inbound rules, and update the sources of the TCP 22 and TCP 6443 rules to `<new-ip>/32`.

This creates **drift**. Afterwards, update `admin_cidr` in `terraform.tfvars` to the same value, and confirm that `terraform plan` reports no changes. Otherwise, the next `terraform apply` will revert the rule to the old IP and lock you out again.

### 4. Verify

```bash
kubectl-aws get nodes
```

The node should be `Ready`. Always use `kubectl-aws`, never bare `kubectl`.

## History

- 2026-11-12: the administrator IP changed. `kubectl-aws` timed out while the applications kept responding, and the rule was updated in the AWS console. See `docs/journal.md`.
