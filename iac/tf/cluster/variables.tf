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
  default     = "reana_sh1"
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

variable "rucio-server-image-tag" {
  description = "The rucio dockerhub image tag"
  type        = string
  default     = "release-1.29.8"
}

variable "rucio-ui-image-tag" {
  description = "The rucio dockerhub image tag"
  type        = string
  default     = "release-1.29.8"
}

variable "rucio-daemons-image-tag" {
  description = "The rucio dockerhub image tag"
  type        = string
  default     = "release-1.29.8"
}

variable "rucio-vre-dn" {
  description = "Domain name of service for which grid host certificates were requested"
  type        = string
  default     = "rucio.vre.cern.ch" #change accordingly
}

variable "rucio-auth-vre-dn" {
  description = "Domain name of service for which grid host certificates were requested"
  type        = string
  default     = "rucio-auth.vre.cern.ch" #change accordingly
}

variable "rucio-ui-vre-dn" {
  description = "Domain name of service for which grid host certificates were requested"
  type        = string
  default     = "rucio-ui.vre.cern.ch" #change accordingly
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
