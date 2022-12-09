variable "ns-name" {
  description = "The namespace to use for ui daemons"
  type        = string
}

variable "release-suffix" {
  description = "The suffix added to the rucio ui release"
  type        = string
}

variable "image-tag" {
  description = "The rucio dockerhub image tag"
  type        = strin
  default     = release-1.29.8
}
