resource "helm_release" "reana-chart" {
  name       = "reana-${var.release-suffix}"
  repository = "https://reanahub.github.io/reana"
  chart      = "reana"
  version    = "0.9.0-alpha.7"
  namespace  = var.ns-name

  set {
    name  = "shared_storage.backend"
    value = var.storage-backend
  }
  /* set {
    name  = "shared_storage.cephfs.availability_zone"
    value = var.availability-zone
  } */
  set {
    name  = "shared_storage.cephfs.cephfs_os_share_access_id"
    value = var.share-access-id
  }
  set {
    name  = "shared_storage.cephfs.cephfs_os_share_id"
    value = var.share-id
  }
  /* set {
    name  = "shared_storage.cephfs.os_secret_name"
    value = var.os-secret-name
  }
  set {
    name  = "shared_storage.cephfs.os_secret_namespace"
    value = var.secret-namespace
  }
  set {
    name  = "shared_storage.cephfs.provisioner"
    value = var.cephfs-provisioner
  } */
  set {
    name  = "shared_storage.cephfs.type"
    value = var.cephfs-type
  }
}