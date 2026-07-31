locals {
  common_tags = {
    Project    = var.project_name
    ManagedBy  = "Terraform"
    Repository = "cloud-native-lab"
    Owner      = var.owner
    Scope      = "bootstrap"
  }
}
