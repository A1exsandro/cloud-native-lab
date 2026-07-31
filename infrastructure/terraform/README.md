# Terraform

This directory contains the Terraform code used to provision Oracle Cloud Infrastructure resources for the Cloud Native Lab.

## Structure

- `bootstrap/` — tenancy-scoped bootstrap stacks
- `environments/` — environment-specific stacks
- `modules/` — reusable Terraform modules

## Execution Flow

1. Apply the bootstrap stack that creates the project compartment
2. Export the resulting compartment OCID
3. Apply the target environment stack
