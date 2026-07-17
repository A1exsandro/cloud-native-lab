resource "oci_core_vcn" "this" {
  compartment_id = var.compartment_ocid

  cidr_blocks = [
    var.vcn_cidr
  ]

  display_name = var.display_name

  dns_label = var.dns_label

  freeform_tags = var.freeform_tags
}
