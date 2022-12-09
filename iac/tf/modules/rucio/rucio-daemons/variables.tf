variable "ns-name" {
  description = "The namespace to use for rucio daemons"
  type        = string
}

variable "release-suffix" {
  description = "The suffix added to the rucio daemons release"
  type        = string
}

variable "rucio-daemons-image-tag" {
  description = "The rucio dockerhub image tag"
  type        = string
}
