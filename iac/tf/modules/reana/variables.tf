variable "ns-name" {
  description = "The namespace to use for reana"
  type        = string
}

variable "release-suffix" {
  description = "The suffix added to the reana release"
  type        = string
}

variable "storage-backend" {
  description = "The reana storage backend"
  type = string
}

variable "share-access-id" {
  description = "The reana share access id"
  type = string
}

variable "share-id" {
  description = "The reana share id"
  type = string
}

variable "cephfs-type" {
  description = "The reana cephfs type"
  type = string
}