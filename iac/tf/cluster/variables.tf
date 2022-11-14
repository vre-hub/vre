variable "keypair-name" {
  description = "The suffix for all cluster resources"
  type        = string
  default     = "eosc-future-keypair"
}

variable "resource-suffix" {
  description = "The cluster resource suffix"
  type = string
  default = "eoscf"
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