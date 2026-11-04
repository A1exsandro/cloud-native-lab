variable "compartment_ocid" {
  description = "OCI Compartment OCID."
  type        = string
}

variable "availability_domain" {
  description = "OCI Availability Domain."
  type        = string
}

variable "display_name" {
  description = "Compute instance display name."
  type        = string
}

variable "shape" {
  description = "OCI Compute shape."
  type        = string
  default     = "VM.Standard.A1.Flex"
}

variable "ocpus" {
  description = "Number of OCPUs."
  type        = number
}

variable "memory_gb" {
  description = "Amount of memory in GB."
  type        = number
}

variable "image_id" {
  description = "OCI image OCID."
  type        = string
}

variable "subnet_id" {
  description = "Public subnet OCID."
  type        = string
}

variable "nsg_ids" {
  description = "Network Security Group OCIDs."
  type        = list(string)
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key."
  type        = string
}

variable "boot_volume_size_gb" {
  description = "Boot volume size in GB."
  type        = number
  default     = 50

  validation {
    condition     = var.boot_volume_size_gb >= 50
    error_message = "The boot volume must be at least 50 GB."
  }
}

variable "freeform_tags" {
  description = "Common resource tags."
  type        = map(string)
  default     = {}
}
