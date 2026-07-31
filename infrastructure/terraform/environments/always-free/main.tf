module "networking" {
  source = "../../modules/networking"

  compartment_ocid    = var.compartment_ocid
  display_name        = "${local.naming.prefix}-vcn"
  dns_label           = "cnl"
  vcn_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.10.0/24"
  private_subnet_cidr = "10.0.20.0/24"
  create_nat_gateway  = false
  freeform_tags       = local.common_tags
}
