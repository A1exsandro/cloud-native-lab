output "vcn_id" {
  description = "OCI VCN OCID."
  value       = module.networking.vcn_id
}

output "vcn_cidr" {
  description = "OCI VCN CIDR block."
  value       = module.networking.vcn_cidr
}

output "default_route_table_id" {
  description = "OCI default route table ID for the VCN."
  value       = module.networking.default_route_table_id
}

output "internet_gateway_id" {
  description = "OCI Internet Gateway OCID."
  value       = module.networking.internet_gateway_id
}

output "nat_gateway_id" {
  description = "OCI NAT Gateway OCID."
  value       = module.networking.nat_gateway_id
}

output "public_route_table_id" {
  description = "OCI public route table OCID."
  value       = module.networking.public_route_table_id
}

output "private_route_table_id" {
  description = "OCI private route table OCID."
  value       = module.networking.private_route_table_id
}

output "public_subnet_id" {
  description = "OCI public subnet OCID."
  value       = module.networking.public_subnet_id
}

output "private_subnet_id" {
  description = "OCI private subnet OCID."
  value       = module.networking.private_subnet_id
}

output "public_nsg_id" {
  description = "OCI public NSG OCID."
  value       = module.networking.public_nsg_id
}

output "private_nsg_id" {
  description = "OCI private NSG OCID."
  value       = module.networking.private_nsg_id
}
