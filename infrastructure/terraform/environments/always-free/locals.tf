locals {
  project = {
    name        = var.project_name
    environment = var.environment
    region      = var.region
  }

  naming = {
    prefix = "${var.project_name}-${var.environment}"
  }

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Repository  = "cloud-native-lab"
    Owner       = var.owner
  }
}
