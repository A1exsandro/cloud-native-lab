variable "tenancy_ocid" {
  description = "OCI tenancy OCID where the compartment will be created."
  type        = string
}

variable "name" {
  description = "Compartment name."
  type        = string
}

variable "description" {
  description = "Compartment description."
  type        = string
}

variable "enable_delete" {
  description = "Whether the compartment can be deleted by Terraform."
  type        = bool
  default     = false
}

variable "freeform_tags" {
  description = "Common tags applied to resources."
  type        = map(string)
  default     = {}
}
