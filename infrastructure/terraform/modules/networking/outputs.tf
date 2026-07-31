output "vcn_id" {
  description = "VCN OCID."
  value       = oci_core_vcn.this.id
}

output "vcn_cidr" {
  description = "VCN CIDR."
  value       = oci_core_vcn.this.cidr_blocks
}

output "default_route_table_id" {
  description = "Default Route Table ID."
  value       = oci_core_vcn.this.default_route_table_id
}

output "internet_gateway_id" {
  description = "Internet Gateway OCID."
  value       = oci_core_internet_gateway.this.id
}

output "nat_gateway_id" {
  description = "NAT Gateway OCID."
  value       = try(oci_core_nat_gateway.this[0].id, null)
}

output "public_route_table_id" {
  description = "Public route table OCID."
  value       = oci_core_route_table.public.id
}

output "private_route_table_id" {
  description = "Private route table OCID."
  value       = oci_core_route_table.private.id
}

output "public_subnet_id" {
  description = "Public subnet OCID."
  value       = oci_core_subnet.public.id
}

output "private_subnet_id" {
  description = "Private subnet OCID."
  value       = oci_core_subnet.private.id
}

output "public_nsg_id" {
  description = "Public NSG OCID."
  value       = oci_core_network_security_group.public.id
}

output "private_nsg_id" {
  description = "Private NSG OCID."
  value       = oci_core_network_security_group.private.id
}
