variable "region" {
  description = "OCI region where resources will be provisioned."
  type        = string
}

variable "compartment_ocid" {
  description = "OCI compartment OCID."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "project_name" {
  description = "Project name."
  type        = string
}

variable "owner" {
  description = "Resource owner."
  type        = string
}

variable "admin_cidr" {
  description = "Administrative IPv4 CIDR allowed to access the instance through SSH."
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key used for instance access."
  type        = string
}

variable "availability_domain" {
  description = "OCI Availability Domain for the compute instance."
  type        = string
}

variable "compute_image_id" {
  description = "OCI image OCID used by the compute instance."
  type        = string
}

variable "instance_ocpus" {
  description = "Number of OCPUs allocated to the instance."
  type        = number
  default     = 2
}

variable "instance_memory_gb" {
  description = "Amount of memory allocated to the instance in GB."
  type        = number
  default     = 12
}

variable "boot_volume_size_gb" {
  description = "Boot volume size in GB."
  type        = number
  default     = 50
}
