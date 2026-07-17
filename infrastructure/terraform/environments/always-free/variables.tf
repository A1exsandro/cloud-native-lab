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
