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

/* variable "availability-zone" {
  description = "The reana availability zone"
  type = string
} */

variable "share-access-id" {
  description = "The reana share access id"
  type = string
}

variable "share-id" {
  description = "The reana os share id"
  type = string
}

/* variable "os-secret-name" {
  description = "The reana os secret name"
  type = string
}

variable "secret-namespace" {
  description = "The reana seceret namespace"
  type = string
}

variable "cephfs-provisioner" {
  description = "The reana cephfs provisioner"
  type = string
} */

variable "cephfs-type" {
  description = "The reana chephfs type"
  type = string
}