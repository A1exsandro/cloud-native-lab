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

output "compute_instance_id" {
  description = "OCI Compute instance OCID."
  value       = module.compute.instance_id
}

output "compute_instance_name" {
  description = "OCI Compute instance name."
  value       = module.compute.instance_name
}

output "compute_public_ip" {
  description = "Public IPv4 address of the compute instance."
  value       = module.compute.public_ip
}

output "compute_private_ip" {
  description = "Private IPv4 address of the compute instance."
  value       = module.compute.private_ip
}

output "compute_shape" {
  description = "OCI Compute instance shape."
  value       = module.compute.shape
}
