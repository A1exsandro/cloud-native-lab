output "compartment_id" {
  description = "OCI compartment OCID for the Cloud Native Lab environment."
  value       = module.identity.compartment_id
}

output "compartment_name" {
  description = "OCI compartment name."
  value       = module.identity.compartment_name
}
