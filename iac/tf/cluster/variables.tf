variable "cluster-resource-suffix" {
  description = "The suffix for all cluster resources"
  type = string
  default = "eoscf"
}

variable "shared-services-ns" {
  description = "The name of the namespace for shared services"
  type = string
  default = "shared-services"
}

variable "rucio-ns" {
  description = "The name of the namespace for rucio"
  type = string
  default = "rucio"
}

variable "monitoring-ns" {
  description = "The name of the namespace for monitoring"
  type = string
  default = "monitoring"
}