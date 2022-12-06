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
  set {
    name  = "shared_storage.cephfs.cephfs_os_share_access_id"
    value = var.share-access-id
  }
  set {
    name  = "shared_storage.cephfs.cephfs_os_share_id"
    value = var.share-id
  }
  set {
    name  = "shared_storage.cephfs.type"
    value = var.cephfs-type
  }
}