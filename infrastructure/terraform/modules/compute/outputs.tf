output "instance_id" {
  description = "Compute instance OCID."
  value       = oci_core_instance.this.id
}

output "instance_name" {
  description = "Compute instance display name."
  value       = oci_core_instance.this.display_name
}

output "public_ip" {
  description = "Public IPv4 address."
  value       = oci_core_instance.this.public_ip
}

output "private_ip" {
  description = "Private IPv4 address."
  value       = oci_core_instance.this.private_ip
}

output "shape" {
  description = "Compute instance shape."
  value       = oci_core_instance.this.shape
}
