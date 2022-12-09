variable "ns-name" {
  description = "The namespace to use for rucio server"
  type        = string
}

variable "release-suffix" {
  description = "The suffix added to the rucio server release"
  type        = string
}

variable "image-tag" {
  description = "The rucio dockerhub image tag"
  type        = string
  default     = "release-1.29.8"
}

variable "rucio-vre-dn" {
  description = "Domain name of service for which grid host certificates were requested"
  type        = string
}

variable "rucio-auth-vre-dn" {
  description = "Domain name of service for which grid host certificates were requested"
  type        = string
}

