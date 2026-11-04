resource "oci_identity_compartment" "this" {
  compartment_id = var.tenancy_ocid
  name           = var.name
  description    = var.description
  enable_delete  = var.enable_delete
  freeform_tags  = var.freeform_tags
}
