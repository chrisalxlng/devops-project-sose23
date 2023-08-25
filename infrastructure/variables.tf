variable "SSH_PUBLIC_KEY_PATH" {
  type = string
  description = "path to the public part of the SSH key pair"
}

variable "EIP_ALLOCATION_ID" {
  type = string
  description = "Elastic IP Allocation ID"
}

variable "ENVIRONMENT" {
  type = string
  description = "Environment"
}