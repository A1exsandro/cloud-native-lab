# Always Free Environment

This directory contains the Terraform configuration for the Oracle Cloud Always Free environment.

The environment consumes reusable modules located under `terraform/modules`.

Infrastructure will be provisioned incrementally following the project roadmap.

## Dependency

This stack depends on a pre-existing OCI compartment.

The recommended workflow is:

1. Apply `bootstrap/compartment`
2. Copy the generated compartment OCID
3. Set `compartment_ocid` in `terraform.tfvars`
4. Run `terraform init`, `terraform plan` and `terraform apply` in this environment
