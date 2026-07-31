# Networking Module

This module provisions the networking foundation for the Cloud Native Lab on Oracle Cloud Infrastructure (OCI).

## Planned Resources

- Virtual Cloud Network (VCN)
- Internet Gateway
- NAT Gateway
- Route Tables
- Public Subnet
- Private Subnet
- Network Security Groups (NSGs)

## Inputs

| Name | Description |
|------|-------------|
| compartment_ocid | OCI compartment identifier |
| vcn_cidr | CIDR block of the VCN |
| public_subnet_cidr | CIDR block of the public subnet |
| private_subnet_cidr | CIDR block of the private subnet |
| display_name | Resource display name |
| dns_label | DNS label |
| create_nat_gateway | Whether to provision a NAT Gateway |
| freeform_tags | Common resource tags |

## Outputs

The module exposes identifiers for the VCN, gateways, route tables, subnets and NSGs.

## Notes

The NAT Gateway is implemented as an optional resource.

For the Always Free environment, it should remain disabled until its eligibility or cost impact is explicitly confirmed for the tenancy.
