variable "location_one" {
  description = "The location of the first cluster and related resources."
  type        = string
  default     = "westeurope"
}

variable "location_two" {
  description = "The location of the second cluster and related resources."
  type        = string
  default     = "eastus"
}

variable "agents_size" {
  default     = "Standard_D2s_v3"
  description = "The default virtual machine size for the Kubernetes agents"
  type        = string
}

variable "kubernetes_version" {
  description = "Specify which Kubernetes release to use. The default used is the latest Kubernetes version available in the region"
  type        = string
  default     = null
}
