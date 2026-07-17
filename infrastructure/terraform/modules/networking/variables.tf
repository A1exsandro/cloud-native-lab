variable "compartment_ocid" {
  description = "OCI Compartment OCID."
  type        = string
}

variable "vcn_cidr" {
  description = "CIDR block for the VCN."
  type        = string
}

variable "display_name" {
  description = "VCN display name."
  type        = string
}

variable "dns_label" {
  description = "DNS label for the VCN."
  type        = string
}

variable "freeform_tags" {
  description = "Common tags applied to resources."
  type        = map(string)
  default     = {}
}
