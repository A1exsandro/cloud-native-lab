output "compartment_id" {
  description = "OCI compartment OCID."
  value       = oci_identity_compartment.this.id
}

output "compartment_name" {
  description = "OCI compartment name."
  value       = oci_identity_compartment.this.name
}

output "compartment_state" {
  description = "OCI compartment lifecycle state."
  value       = oci_identity_compartment.this.state
}
