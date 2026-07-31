module "identity" {
  source = "../../modules/identity"

  tenancy_ocid = var.tenancy_ocid
  name         = var.compartment_name
  description  = var.compartment_description

  freeform_tags = local.common_tags
}
