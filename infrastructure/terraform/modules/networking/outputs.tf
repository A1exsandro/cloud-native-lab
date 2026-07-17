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
