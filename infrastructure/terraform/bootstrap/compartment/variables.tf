variable "region" {
  description = "OCI region used for provider configuration."
  type        = string
}

variable "tenancy_ocid" {
  description = "OCI tenancy OCID where the compartment will be created."
  type        = string
}

variable "compartment_name" {
  description = "Dedicated compartment name for the project."
  type        = string
}

variable "compartment_description" {
  description = "Compartment description."
  type        = string
}

variable "owner" {
  description = "Resource owner."
  type        = string
}

variable "project_name" {
  description = "Project name."
  type        = string
}
