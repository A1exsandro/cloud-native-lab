variable "ssh_public_key_path" {
  description = "Path to the SSH public key."
  type        = string
  default     = "~/.ssh/cloud-native-lab/aws-ohio.pub"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.medium"
}

variable "root_volume_size" {
  description = "EC2 root volume size in GB."
  type        = number
  default     = 40
}
