# Bootstrap Compartment

This Terraform stack provisions the dedicated OCI compartment used by the Cloud Native Lab.

It must be applied before the `environments/always-free` stack because the environment depends on the resulting compartment OCID.

## Usage

1. Copy `terraform.tfvars.example` to `terraform.tfvars`
2. Fill in the tenancy OCID and owner fields
3. Run `terraform init`
4. Run `terraform plan`
5. Run `terraform apply`
6. Copy the resulting `compartment_id` into `environments/always-free/terraform.tfvars`
