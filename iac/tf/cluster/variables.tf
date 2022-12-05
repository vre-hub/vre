variable "resource-suffix" {
  description = "The cluster resource suffix"
  type        = string
  default     = "cvre"
}

variable "cluster-template-name" {
  description = "The cluster template"
  type        = string
  default     = "kubernetes-1.22.9-1-multi"
}

variable "cluster-name" {
  description = "The openstack cluster name"
  type        = string
  default     = "cern-vre"
}

variable "cluster-keypair-name" {
  description = "The cluster keypair name"
  type        = string
  default     = "cern-vre-keypair"
}

variable "logging-producer" {
  description = "The cluster logging producer"
  type        = string
  default     = "eosc-future"
}

variable "ns-shared-services" {
  description = "The name of the namespace for shared services"
  type        = string
  default     = "shared-services"
}

variable "ns-rucio" {
  description = "The name of the namespace for rucio"
  type        = string
  default     = "rucio"
}

variable "ns-monitoring" {
  description = "The name of the namespace for monitoring"
  type        = string
  default     = "monitoring"
}

variable "ns-reana" {
  description = "The name of the namespace for reana"
  type        = string
  default     = "reana"
}

variable "ns-jupyterhub" {
  description = "The name of the namespace for jupyterhub"
  type        = string
  default     = "jupyterhub"
}