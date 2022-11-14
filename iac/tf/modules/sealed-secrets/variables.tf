variable "ns-name" {
  description = "The namespace to use for sealed-secrets"
  type        = string
}

variable "release-suffix" {
  description = "The suffix added to the sealed-secrets release"
  type        = string
}