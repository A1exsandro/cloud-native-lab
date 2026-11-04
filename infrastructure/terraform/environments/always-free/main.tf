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
  admin_cidr          = var.admin_cidr
}

module "compute" {
  source = "../../modules/compute"

  compartment_ocid    = var.compartment_ocid
  availability_domain = var.availability_domain
  display_name        = "${local.naming.prefix}-vm"
  shape               = "VM.Standard.A1.Flex"
  ocpus               = var.instance_ocpus
  memory_gb           = var.instance_memory_gb
  image_id            = var.compute_image_id
  subnet_id           = module.networking.public_subnet_id
  nsg_ids             = [module.networking.public_nsg_id]
  ssh_public_key_path = var.ssh_public_key_path
  boot_volume_size_gb = var.boot_volume_size_gb
  freeform_tags       = local.common_tags
}
