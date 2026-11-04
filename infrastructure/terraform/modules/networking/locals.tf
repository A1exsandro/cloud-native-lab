locals {
  resource_name = var.display_name
  name_prefix   = trimsuffix(var.display_name, "-vcn")

  labels = {
    internet_gateway = "${local.name_prefix}-igw"
    nat_gateway      = "${local.name_prefix}-nat"
    public_rt        = "${local.name_prefix}-public-rt"
    private_rt       = "${local.name_prefix}-private-rt"
    public_subnet    = "${local.name_prefix}-public-subnet"
    private_subnet   = "${local.name_prefix}-private-subnet"
    public_nsg       = "${local.name_prefix}-public-nsg"
    private_nsg      = "${local.name_prefix}-private-nsg"
  }
}
