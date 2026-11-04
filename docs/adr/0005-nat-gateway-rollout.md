# ADR-0005 — Keep NAT Gateway Disabled By Default In Always Free

**Status:** Accepted

**Date:** 2026-07-31

---

## Context

The target network topology includes a private subnet with outbound internet access through a NAT Gateway.

However, the Oracle Cloud Infrastructure Always Free documentation updated on 2026-06-29 explicitly lists VCN, load balancer and network load balancer benefits, but does not clearly identify NAT Gateway as an Always Free entitlement.

Because this project is intentionally constrained to Oracle Cloud Always Free resources, ambiguous network costs should be treated conservatively.

---

## Decision

The Terraform networking module will implement NAT Gateway support, but the `always-free` environment will keep it disabled by default.

Private subnet and private route table resources will still be provisioned so the topology remains ready for a future NAT activation.

NAT Gateway can be enabled later after explicit tenancy-level cost verification.

---

## Alternatives Considered

- Enable NAT Gateway immediately in the Always Free environment
- Omit NAT Gateway support from the Terraform module entirely

Enabling NAT Gateway immediately was rejected because the current Always Free documentation does not clearly confirm its eligibility.

Omitting NAT Gateway support entirely was rejected because the target architecture still requires it for a production-like private subnet pattern.

---

## Consequences

Positive:

- Preserves Always Free cost discipline
- Keeps the network topology ready for future expansion
- Avoids reworking the module when the compute layer introduces private workloads

Negative:

- The private subnet initially has no default internet egress route
- Some future workloads may need temporary placement in the public subnet until NAT is enabled

---

## References

- infrastructure/terraform/modules/networking
- infrastructure/terraform/environments/always-free
- https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm
