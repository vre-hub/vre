variable "ns_name" {
  description = "The namespace to use for sealed-secrets"
  type        = string
}

variable "release_suffix" {
  description = "The suffix added to the sealed-secrets release"
  type        = string
}