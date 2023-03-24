# General variables

variable "resource-suffix" {
  description = "The cluster resource suffix"
  type        = string
  default     = "cvre"
}

# Openstack variables

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

variable "reana-share-name" {
  description = "The reana share name"
  type        = string
  default     = "cvre-reana"
}

variable "cephfs-type" {
  description = "The cephfs share type"
  type        = string
  default     = "Meyrin CephFS"
}

# Kubernetes variables

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
  default     = "jhub"
}

variable "ns-dask-gateway" {
  description = "The name of the namespace for dask-gateway"
  type        = string
  default     = "dask-gateway"
}

variable "ns-daskhub" {
  description = "The name of the namespace for daskhub"
  type        = string
  default     = "daskhub"
}

# GitHub

variable "github-token" {
  description = "Personal access token for GitHub with repo scope"
  sensitive   = true
  type        = string
}

variable "github-org" {
  description = "Name of GitHub organisation"
  type        = string
  default     = "vre-hub"
}

variable "github-repository" {
  description = "Name of GitHub repo"
  type        = string
  default     = "vre"
}

# Flux

variable "flux-target-path" {
  description = "Target path to sync flux manifests"
  type        = string
  default     = "iac/cluster/flux"
}
