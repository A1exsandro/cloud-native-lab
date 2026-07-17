module "networking" {
  source = "../../modules/networking"

  compartment_ocid = var.compartment_ocid

  display_name = "${local.naming.prefix}-vcn"

  dns_label = "cnl"

  vcn_cidr = "10.0.0.0/16"

  freeform_tags = local.common_tags
}
